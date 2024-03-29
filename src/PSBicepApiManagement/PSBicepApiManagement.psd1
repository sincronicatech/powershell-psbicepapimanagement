#
# Module manifest for module 'PSBicepParser'
#
# Generated by: Daniele Francioni
#
# Generated on: 17/06/2022
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'PSBicepApiManagement.psm1'

    # Version number of this module.
    ModuleVersion = '0.0.2'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID = 'f9e62268-8345-40ea-a007-5e3cf57a5ecb'

    # Author of this module
    Author = 'Daniele Francioni'

    # Company or vendor of this module
    CompanyName = 'Sincronica'

    # Copyright statement for this module
    # Copyright = '(c) Daniele Francioni. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Powershell module to export/import a single api from Azure Api Management using Azure Bicep.'

    # Minimum version of the PowerShell engine required by this module
    # PowerShellVersion = ''

    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # ClrVersion = ''

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @(
        @{
            ModuleName = 'PSBicepParser'
            ModuleVersion = '0.1.1'; 
        },
        'Microsoft.PowerShell.ConsoleGuiTools', 
        'Az.ApiManagement', 
        'Az.Accounts', 
        'Az.Resources',
        'Az.ApiManagement'

    )

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    #FormatsToProcess = @('PSBicepParser.objectFormat.ps1xml')

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = @(
        'scripts\Copy-PSBicepApiManagementApiWithGUI.ps1',
        'scripts\Export-PSBicepApiManagementApi.ps1',
        'scripts\Import-PSBicepApiManagementApi.ps1',
        'scripts\Export-PSBicepApiManagementService.ps1',
        'scripts\Write-PSBicepApiManagementExportedResources.ps1',
        'scripts\Export-PSBicepApiManagementSubscriptionData.ps1'
    )

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @(
        'Copy-PSBicepApiManagementApiWithGUI',
        'Export-PSBicepApiManagementApiVersionSet',
        'Export-PSBicepApiManagementApi',
        'Import-PSBicepApiManagementApi'
    )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = '*'

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @(
                'PSEdition_Core',
                'Windows',
                'Linux'
            )

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/sincronicatech/powershell-psbicepapimanagement'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            # Prerelease = ''

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

