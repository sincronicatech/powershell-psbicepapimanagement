<#
    .Synopsis
        Export a single Api from an Api Management instance as Bicep file

    .Description
        Generates a Bicep file of a single Api. It includes all child objects and referes all external objects as existing
        resources in the Bicep file

    .Parameter SubcriptionId
        Subcription id containing the source Api Management instance

    .Parameter ResourceGroupName
        Name of the resource group containing the source Api Management instance

    .Parameter ApiManagementName
        Name of the source Api Management instance

    .Parameter ApiId
        ApiId of the Api to export.
    
    .Parameter TargetFile
        Path of the target Bicep file
        
    .Example
        # Exports an Api
        Export-PSBicepApiManagementApi -SubscriptionId '00000000-1111-2222-3333-444444444444' -ResourceGroupName 'Api-management-CICD' -ApiManagementName 'Api-management-src' -ApiId 'source-Api-v2' -TargetFile .\ApiExport.bicep

#>

function Export-PSBicepApiManagementApi (
    $SubscriptionId ,
    $ResourceGroupName ,
    $ApiManagementName ,
    $ApiId ,
    $TargetFile
)
{
    $ErrorActionPreference= 'Stop'
    #Import-Module PSBicepParser

    write-host "Connecting to Subscription Id $SubscriptionId"
    Set-AzContext -SubscriptionId $SubscriptionId|Out-Null
    $sourceApiManagement= Get-AzApiManagement -Name $ApiManagementName -ResourceGroupName $ResourceGroupName

    $tempFile = "$($env:TEMP)\$(get-random).json"
    write-host "Exporting Api Management to $tempFile"
    $exportFile = Export-AzResourceGroup -ResourceGroupName $ResourceGroupName -Resource $sourceApiManagement.Id -Path "$tempFile" -IncludeParameterDefaultValue
    bicep decompile $exportFile.Path --outfile "$($exportFile.Path).bicep"|Out-Null
    $bicepData = Get-Content "$($exportFile.Path).bicep" -Raw   

    Remove-Item "$tempFile"
    write-host "  $tempFile removed"
    Remove-Item "$($exportFile.Path).bicep"
    write-host "  $($exportFile.Path).bicep removed"

    $bicepDocument = $bicepData|ConvertFrom-PSBicepDocument 

    $sourceApiManagement= $bicepDocument.Resources|Where-Object{$_.ResourceType.StartsWith('''Microsoft.ApiManagement/service@')}

    $ResourcesToBeAnalyzed = @()
    $ResourcesAnalyzed = @()

    write-host "Searching Api Id $ApiId"
    $ApiResource = $bicepDocument.Resources|Where-Object{$_.ResourceType.StartsWith('''Microsoft.ApiManagement/service/apis@') -and $_.Name -eq "'$Apiid'"}
    if($null -ne $ApiResource.Attributes.properties.apiVersionSetId)
    {
        write-host "Searching Api Version Set"
        #Version set will be exported, so that it will be created if not already existig
        $ApiVersionSetIdentifier = $ApiResource.Attributes.properties.apiVersionSetId.Split('.')[0];
        $ApiVersionSetResource = Resolve-PSBicepReference -Identifier $ApiVersionSetIdentifier -Document $bicepDocument
        $ResourcesAnalyzed += $ApiVersionSetResource 
    }
    $ResourcesToBeAnalyzed += $ApiResource
    
    write-host "Searching child resources to be exported"

    $resourceCounter = 0
    while($resourceCounter -lt $ResourcesToBeAnalyzed.Length){ #since there is no native Stack object on Powershell (other than using the .net version), the script will use an array and an incremental index to analyze all data inside the array
        $ResourceToAnalyze = $ResourcesToBeAnalyzed[$resourceCounter];
        $ResourcesToBeAnalyzed += $bicepDocument.Resources|Where-Object{$_.Parent -eq $ResourceToAnalyze.Identifier}
        $ResourcesAnalyzed+=$ResourceToAnalyze;
        $resourceCounter+=1
    }

    write-host "Searching outer dependencies"
    #These objects will not be exported, but will be referred as existing in the outer script

    $exportedIdentifiers = $ResourcesAnalyzed.Identifier
    $AllReferredIdentifiers=@()
    foreach($resourceAnalyzed in $resourcesAnalyzed){
        $AllReferredIdentifiers += Get-PSBicepReference -ElementObject $resourceAnalyzed
    }


    $AllReferredIdentifiers=$AllReferredIdentifiers|Select-Object -unique
    $referenceCounter = 0;

    while($referenceCounter -lt $AllReferredIdentifiers.Count){
        $id = $AllReferredIdentifiers[$referenceCounter]
        $referenceCounter+=1
        
        if($exportedIdentifiers -contains $id)
        {
            continue;
        }
        $ReferredOuterResource = Resolve-PSBicepReference -Identifier $id -Document $bicepDocument
        $ResourceToAdd=$null
        if($ReferredOuterResource.ElementType -eq "Resource")
        {
            $ResourceToAdd= New-PSBicepResource -Identifier $id -ResourceType $ReferredOuterResource.ResourceType -IsExisting:$true -Name $ReferredOuterResource.Name
        }
        else{
            if($ReferredOuterResource.ElementType -eq 'Param' -and $ReferredOuterResource.Identifier -eq $sourceApiManagement.Name){
                $ReferredOuterResource.DefaultValue='''#TargetApiManagement#'''
            }
            $ResourceToAdd=$ReferredOuterResource;
        }
        $ResourcesAnalyzed+=$ResourceToAdd;
        $ReferredIdentifiers = Get-PSBicepReference -ElementObject $ResourceToAdd
        foreach($referredIdentifier in $ReferredIdentifiers)
        {
            if(-not($AllReferredIdentifiers -contains $referredIdentifier))
            {
                $AllReferredIdentifiers+=$referredIdentifier;
            }
        }
    }

    write-host "Writing new bicep document $TargetFile"
    $newDocument = New-PSBicepDocument
    foreach($obj in $resourcesAnalyzed){
        $newDocument.Add($obj)
    }

    $newDocument|ConvertTo-PSBicepDocument|out-file "$TargetFile"

}