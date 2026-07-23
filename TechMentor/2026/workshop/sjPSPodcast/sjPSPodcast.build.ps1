<#
    Invoke-Build script for sjPSPodcast.
    Run with: Invoke-Build (or .\sjPSPodcast.build.ps1) for the Build/Test/Publish pipeline,
    or Invoke-Build <TaskName> to run a single task, e.g. Invoke-Build Test.

    Build refuses to overwrite an already-built version under Output\, and Publish refuses
    to overwrite an already-published version in the repository -- bump -ModuleVersion for a
    new release, or pass -Force to overwrite either one intentionally. Clean is not part of
    the default pipeline; run Invoke-Build Clean explicitly to wipe all build output.
#>

param (
    [string]$ModuleVersion = '0.1.0',
    [string]$RepositoryName = 'LocalPSRepo',
    [string]$RepositoryPath = 'C:\Users\steve\OneDrive\PSRepo',
    [switch]$Force
)

$ModuleName = 'sjPSPodcast'
$OutputRoot = Join-Path -Path $BuildRoot -ChildPath 'Output'
$ModuleOutDir = Join-Path -Path $OutputRoot -ChildPath "$ModuleName\$ModuleVersion"

task Clean {
    if (Test-Path -LiteralPath $OutputRoot) {
        Remove-Item -LiteralPath $OutputRoot -Recurse -Force
    }
}

task Build {
    if (Test-Path -LiteralPath $ModuleOutDir) {
        if (-not $Force) {
            throw "Version $ModuleVersion of $ModuleName already exists in Output. " +
                'Bump -ModuleVersion for a new build, or pass -Force to overwrite it.'
        }

        Remove-Item -LiteralPath $ModuleOutDir -Recurse -Force
    }

    New-Item -ItemType Directory -Force -Path $ModuleOutDir | Out-Null

    $privateFunctions = Get-ChildItem -Path (Join-Path -Path $BuildRoot -ChildPath 'Private') -Filter '*.ps1'
    $publicFunctions = Get-ChildItem -Path (Join-Path -Path $BuildRoot -ChildPath 'Public') -Filter '*.ps1'

    $psm1Content = foreach ($file in @($privateFunctions) + @($publicFunctions)) {
        "# Source: $($file.Name)"
        Get-Content -LiteralPath $file.FullName -Raw
    }
    $psm1Content += "Export-ModuleMember -Function $($publicFunctions.BaseName -join ', ')"

    $psm1Path = Join-Path -Path $ModuleOutDir -ChildPath "$ModuleName.psm1"
    Set-Content -LiteralPath $psm1Path -Value ($psm1Content -join "`r`n`r`n") -Encoding utf8

    Copy-Item -Path (Join-Path -Path $BuildRoot -ChildPath 'Formats\*.ps1xml') -Destination $ModuleOutDir
    Copy-Item -Path (Join-Path -Path $BuildRoot -ChildPath 'Types\*.ps1xml') -Destination $ModuleOutDir

    $manifestPath = Join-Path -Path $ModuleOutDir -ChildPath "$ModuleName.psd1"
    Copy-Item -Path (Join-Path -Path $BuildRoot -ChildPath "$ModuleName.psd1") -Destination $manifestPath

    $updateModuleManifestSplat = @{
        Path              = $manifestPath
        ModuleVersion     = $ModuleVersion
        FunctionsToExport = $publicFunctions.BaseName
        FormatsToProcess  = "$ModuleName.Format.ps1xml"
        TypesToProcess    = "$ModuleName.Types.ps1xml"
    }
    Update-ModuleManifest @updateModuleManifestSplat
}

task Test Build, {
    $manifestPath = Join-Path -Path $ModuleOutDir -ChildPath "$ModuleName.psd1"
    Import-Module -Name $manifestPath -Force

    $invokePesterSplat = @{
        Path     = Join-Path -Path $BuildRoot -ChildPath 'Tests'
        PassThru = $true
    }
    $result = Invoke-Pester @invokePesterSplat

    Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue

    if ($result.FailedCount -gt 0) {
        throw "$($result.FailedCount) Pester test(s) failed."
    }
}

task Publish Test, {
    if (-not (Test-Path -LiteralPath $RepositoryPath)) {
        New-Item -ItemType Directory -Force -Path $RepositoryPath | Out-Null
    }

    if (-not (Get-PSResourceRepository -Name $RepositoryName -ErrorAction SilentlyContinue)) {
        $registerPSResourceRepositorySplat = @{
            Name    = $RepositoryName
            Uri     = $RepositoryPath
            Trusted = $true
        }
        Register-PSResourceRepository @registerPSResourceRepositorySplat
    }

    $findPSResourceSplat = @{
        Name        = $ModuleName
        Version     = $ModuleVersion
        Repository  = $RepositoryName
        ErrorAction = 'SilentlyContinue'
    }
    $existing = Find-PSResource @findPSResourceSplat

    if ($existing -and -not $Force) {
        throw "Version $ModuleVersion of $ModuleName is already published to $RepositoryName. " +
            'Bump -ModuleVersion for a new release, or pass -Force to overwrite it.'
    }

    $publishPSResourceSplat = @{
        Path       = $ModuleOutDir
        Repository = $RepositoryName
    }
    Publish-PSResource @publishPSResourceSplat
}

task . Build, Test, Publish
