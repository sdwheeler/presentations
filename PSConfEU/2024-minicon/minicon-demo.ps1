# What's new in PowerShell 7.5 - https://learn.microsoft.com/powershell/scripting/whats-new/what-s-new-in-powershell-75
## Experimental features
### Mainstream - show docs - https://learn.microsoft.com/powershell/scripting/learn/experimental-features
### - PSModuleAutoLoadSkipOfflineFiles
### - Demo - Jason - PSCommandWithArgs - copy from docs
### - Demo - Jason - PSCommandNotFoundSuggestion

Get

### New experiemental features
### - PSSerializeJSONLongEnumAsNumber - ConvertTo-Json now treats large enums as numbers
### - PSRedirectToVariable - Allow redirecting to a variable

dir > variable:output

$output

###   - Copy example from docs
###     Redirect warning stream to a variable

. {
    "Output 1"
    Write-Warning "Warning, Warning!"
    "Output 2"
} 3> variable:warnings

$warnings

### - PSNativeWindowsTildeExpansion - Add tilde expansion for windows native executables

dir ~\

cmd.exe /c echo ~

## New cmdlets - ConvertTo-CliXml & ConvertFrom-CliXml
### https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/convertto-clixml
### The point is the pipeline (vs. Export-CliXml)

$ps = get-process -id $pid
$ps | fl *

$xml = $ps | ConvertTo-CliXml
$xml

$fromxml = ConvertFrom-CliXml $xml
$fromxml

$ps.pstypenames
$fromxml.pstypenames

## General improvements
### - Tab completions
### - Web cmdlets
### - Cmdlet improvements
###   - Demo - Array addition performace improvement from jborean93

function Test-ArrayAddition {
    $tests = @{
        'Explicit Assignment' = {
            param($count)

        $result = foreach($i in 1..$count) {
                $i
            }
        }
        'List<T>.Add(T)' = {
            param($count)

            $result = [Collections.Generic.List[int]]::new()
            foreach($i in 1..$count) {
                $result.Add($i)
            }
        }
        'Array+= Operator' = {
            param($count)

            $result = @()
            foreach($i in 1..$count) {
                $result += $i
            }
        }
    }

    5kb, 10kb | ForEach-Object {
        $groupResult = foreach($test in $tests.GetEnumerator()) {
            $ms = (Measure-Command { & $test.Value -Count $_ }).TotalMilliseconds

    [pscustomobject]@{
                CollectionSize    = $_
                Test              = $test.Key
                TotalMilliseconds = [math]::Round($ms, 2)
            }

    [GC]::Collect()
            [GC]::WaitForPendingFinalizers()
        }

    $groupResult = $groupResult | Sort-Object TotalMilliseconds
        $groupResult | Select-Object *, @{
            Name       = 'RelativeSpeed'
            Expression = {
                $relativeSpeed = $_.TotalMilliseconds / $groupResult[0].TotalMilliseconds
                $speed = [math]::Round($relativeSpeed, 2).ToString() + 'x'
                if ($speed -eq '1x') { $speed } else { $speed + ' slower' }
            }
        } | ft -a
    }
}

Test-ArrayAddition
