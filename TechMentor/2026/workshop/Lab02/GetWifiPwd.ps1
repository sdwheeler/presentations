<#######################################################################################
# Lab02 - stretch goal
# - Add argument completion for the NetworkName parameter of Get-sjWifiPassword
#   Tab completion should show the network names currently registered in the system
#######################################################################################>
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