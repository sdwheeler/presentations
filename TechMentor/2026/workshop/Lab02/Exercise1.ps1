<#######################################################################################
# Lab02
# - Add comment-based help for both functions
# - Add parameter validation for for the Path parameter in Convert-sjBinaryToText
# - Add parameter validation for the OutputPath parameter in Convert-sjTextToBinary
#######################################################################################>
function Convert-sjBinaryToText {
  param
  (
    [Parameter(Mandatory)]
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
  param
  (
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
