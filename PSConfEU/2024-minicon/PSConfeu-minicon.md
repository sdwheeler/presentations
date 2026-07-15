PSConf.eu miniCon - What's new in PS 7.5

- Intro - 5-10 min
  - Who are we? - Both of us
  - Investment in infrastructure - Jason
    - quality, security, & stability
    - Intro Community contributions
  - Agenda - Sean
    - Experimental
    - New cmdlets
    - Updated modules
    - Breaking changes
    - Cmdlet and UX improvements

- Highlights
  - Breaking changes - 5min - show (Sean) the docs and highlight these two
    - Blocking help is a security improvement
    - The Windows installer now remembers installation options used and uses them to initialize
      options for the next installation

  - Experimental features
    - Mainstream - show docs - https://learn.microsoft.com/powershell/scripting/learn/experimental-features
      - PSModuleAutoLoadSkipOfflineFiles
      - Demo - Jason - PSCommandWithArgs - copy from docs
      - Demo - Jason - PSCommandNotFoundSuggestion
        - Type `get` and hit enter
        - Remind people about Predictive IntelliSense and F2 menu completion
    - New
      - PSSerializeJSONLongEnumAsNumber - ConvertTo-Json now treats large enums as numbers
      - Demo - Jason - PSRedirectToVariable - Allow redirecting to a variable
        - dir > variable:output
        - Or copy example from docs
      - Demo - Sean - PSNativeWindowsTildeExpansion - Add tilde expansion for windows native executables
        - Shout "Cross Platform!"
        - Show tab ~ expansion vs this feature

  - New cmdlets - demo - Sean
    - https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/convertto-clixml?view=powershell-7.5
    - The point is the pipeline (vs. Export-CliXml)

      ```powershell
      $ps = get-process -id $pid
      $xml = $ps | ConvertTo-CliXml
      $xml
      $ps | fl *
      $fromxml = ConvertFrom-CliXml $xml
      $fromxml
      $fromxml.pstypenames
      $ps.pstypenames
      ```

  - General improvements - Sean
    - Show the docs and hit the highlights
      - Tab completions
      - Web cmdlets
      - Cmdlet improvements
        - Demo - Performace improvement from jborean93 - Sean - Jason make slide (racecar)
    - Community contributions graphics
      - At least 36 community contributors to 7.3-7.5
      - Around 150 PRs merged
      - Top 3 accounted for 105 PRs

        |   GitHub Id   |  7.3  |  7.4  |  7.5  | Grand Total |
        | ------------- | :---: | :---: | :---: | ----------: |
        | @MartinGC94   |  19   |  32   |   8   |          59 |
        | @CarloToso    |   2   |  26   |   3   |          31 |
        | @ArmaanMcleod |   2   |   2   |  11   |          15 |

```powershell
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
```