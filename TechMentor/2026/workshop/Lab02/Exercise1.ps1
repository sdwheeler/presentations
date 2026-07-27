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

function Get-sjWifiPassword {

  param (
    [parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]$NetworkName
  )

  begin {
    if ((Get-Command -Name 'netsh').Source -ne "$env:SystemRoot\System32\netsh.exe") {
      throw 'netsh command is not in the proper location'
    }
    # Write-Host "Network name:$NetworkName" -ForegroundColor Yellow
  }

  process {
    # Write-Host "Network name:$NetworkName" -ForegroundColor Cyan
    if (-not ($PSBoundParameters.ContainsKey('NetworkName'))) {
      $NetworkName = (
        netsh wlan show profile | Select-String ' : (.+)$'
      ).Matches.Groups.Where({ $_.Name -eq 1 }).Value
    }
    foreach ($item in $NetworkName) {
      # Write-Host "Network name:$item" -ForegroundColor Cyan
      [PSCustomObject]@{
        Network = $item
        Password = (
          netsh wlan show profile name="$item" key=clear |
            Select-String 'Key Content\s+:\s(.+)$'
        ).Matches.Groups.Where({ $_.Name -eq 1 }).Value
      }
    }
  }

  end {
    # Write-Host "Network name:$NetworkName" -ForegroundColor Green
  }
}