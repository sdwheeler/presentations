<#######################################################################################
# Lab02
# - Add comment-based help for both functions
# - Add parameter validation for for the Path parameter in Convert-sjBinaryToText
#######################################################################################>
function Convert-sjBinaryToText {
    <#
    .SYNOPSIS
    Converts a binary file to a Base64-encoded text string.

    .PARAMETER Path
    The path to the binary file to convert.

    .EXAMPLE
    Convert-sjBinaryToText -Path "C:\path\to\file.bin"

    .EXAMPLE
    Convert-sjBinaryToText -Path "C:\path\to\file.bin" | Set-Clipboard

    Copies the Base64-encoded string to the clipboard.

    .NOTES
    The Path parameter is validated to ensure it points to an existing file.
    #>
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$Path
    )

    try {
        $Bytes = [System.IO.File]::ReadAllBytes($Path)
        [System.Convert]::ToBase64String($Bytes)
    } catch {
        throw $_
    }
}


function Convert-sjTextToBinary {
    <#
    .SYNOPSIS
    Converts a Base64-encoded text string back to a binary file.

    .PARAMETER Text
    The Base64-encoded text string to convert.

    .PARAMETER OutputPath
    The path where the binary file will be saved.

    .EXAMPLE
    Convert-sjTextToBinary -Text "Base64String" -OutputPath "C:\path\to\output.bin"

    .EXAMPLE
    Convert-sjTextToBinary -Text (Get-Clipboard) -OutputPath "C:\path\to\output.bin"

    Get a Base64 string from the clipboard, converts it to binary, and saves it as a binary file.
    #>
    param (
        [Parameter(Mandatory)]
        [string]$Text,

        [Parameter(Mandatory)]
        [string]$OutputPath
    )

    try {
        $Bytes = [System.Convert]::FromBase64String($Text)
        [System.IO.File]::WriteAllBytes($OutputPath, $Bytes)
    } catch {
        throw $_
    }
}
