
# Dot Source Public function and export them to user
Get-ChildItem -Path $PSScriptRoot/Public -ErrorAction Ignore -Recurse | ForEach-Object -Process {
    Write-Verbose -Verbose -Message "Importing Public $($_.BaseName)"
    . $_.FullName
    # Export-ModuleMember -Function $_.BaseName -Verbose
}

# Dot Source Private functions (no Export)
Get-ChildItem -Path $PSScriptRoot/Private -ErrorAction Ignore -Recurse | ForEach-Object -Process {
    Write-Verbose -Verbose -Message "Importing Private $($_.BaseName)"
    . $_.FullName
}

# For private functions to be private, you need to export only the public functions. You can
# export the functions using Export-ModuleMember or by listing them in the module manifest.