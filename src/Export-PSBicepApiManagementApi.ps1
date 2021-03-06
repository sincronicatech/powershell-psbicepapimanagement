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

    $bicepDocument = Export-PSBicepApiManagementService -SubscriptionId $SubscriptionId -ResourceGroupName $ResourceGroupName -ApiManagementName $ApiManagementName
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
    
    Write-PSBicepApiManagementExportedResources -bicepDocument $bicepDocument -sourceApiManagement $sourceApiManagement -ResourcesToBeAnalyzed $ResourcesToBeAnalyzed -ResourcesAnalyzed $ResourcesAnalyzed -TargetFile $TargetFile

}