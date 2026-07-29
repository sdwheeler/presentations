# PlatyPS Demo script
# https://learn.microsoft.com/powershell/module/microsoft.powershell.platyps/new-markdowncommandhelp
throw "Don't run this script using F5. Use F8 to run individual selections."

# 1. Create markdown help a single command

Import-Module Documentarian
$newMarkdownCommandHelpSplat = @{
    CommandInfo    = Get-Command Convert-MDLinks
    OutputFolder   = '.\new'
    HelpVersion    = '1.0.0.0'
    WithModulePage = $true
}
New-MarkdownCommandHelp @newMarkdownCommandHelpSplat

# 2. Create markdown help for a module

$newMarkdownCommandHelpSplat = @{
    ModuleInfo     = Get-Module Documentarian
    OutputFolder   = '.\new'
    HelpVersion    = '1.0.0.0'
    WithModulePage = $true
    Force          = $true
}
New-MarkdownCommandHelp @newMarkdownCommandHelpSplat

# 3. Convert 0.14 content to new format

Measure-PlatyPSMarkdown -Path .\old\Microsoft.PowerShell.PlatyPS\*.md |
    Where-Object Filetype -match 'CommandHelp' |
    Import-MarkdownCommandHelp -Path {$_.FilePath} |
    Export-MarkdownCommandHelp -OutputFolder .\new

bc .\old .\new

# 4. Convert markdown at scale

dir D:\Git\PS-Docs\PowerShell-Docs\reference\7.5\* -dir |
    ForEach-Object { Measure-PlatyPSMarkdown -Path "$($_.FullName)\*.md" } |
    Where-Object Filetype -match 'CommandHelp' |
    Import-MarkdownCommandHelp -Path {$_.FilePath} |
    Export-YamlCommandHelp -OutputFolder .\new

# 5. Using the PlatyPS object model to create tools


function Test-ParameterInfo {
    [CmdletBinding(DefaultParameterSetName='Path')]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ParameterSetName='Path',
            Position=0
        )]
        [SupportsWildcards()]
        [string[]]$Path,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            ParameterSetName='LiteralPath',
            Position=[int]::MinValue
        )]
        [Alias('PSPath', 'LP')]
        [string]$LiteralPath
    )

    begin {
        $platyps = Get-Module Microsoft.PowerShell.PlatyPS
        if ($null -eq $platyps) {
            Import-Module Microsoft.PowerShell.PlatyPS
        }
        if ($PSBoundParameters.ContainsKey('Path')) {
            $PathsToProcess = dir $Path | Measure-PlatyPSMarkdown |
                Where-Object Filetype -match 'CommandHelp' |
                Select-Object -ExpandProperty FilePath
        } else {
            $PathsToProcess = dir $LiteralPath | Measure-PlatyPSMarkdown |
                Where-Object Filetype -match 'CommandHelp' |
                Select-Object -ExpandProperty FilePath
        }
        $CommonParameters = [System.Management.Automation.PSCmdlet]::CommonParameters
    }

    process {
        foreach ($p in $PathsToProcess) {
            $results = @{}
            $mdInfo = Import-MarkdownCommandHelp -Path $p
            $cmdInfo = Get-Command -Name $mdInfo.Title
            $cmdParameters = $cmdInfo.Parameters.Keys | Where-Object {$_ -notin $CommonParameters}
            foreach ($cp in $cmdParameters) {
                $results.Add($cp, [pscustomobject]@{
                    Command      = $mdInfo.Title
                    Name         = $cp
                    IsDefined    = $true
                    IsDocumented = $false
                })
            }
            foreach ($mdp in $mdInfo.Parameters.Name) {
                if ($mdp -in $results.Keys) {
                    $results[$mdp].IsDocumented = $true
                } else {
                    $results.Add($mdp, [pscustomobject]@{
                        Command      = $mdInfo.Title
                        Name         = $mdp
                        IsDefined    = $false
                        IsDocumented = $true
                    })
                }
            }
            $results.Values | Sort-Object Command, Name
        }
    }
}

Test-ParameterInfo -Path .\old\Microsoft.PowerShell.PSResourceGet\*.md
