function Get-PSPodcast {
    <#
    .SYNOPSIS
    Retrieve and optionally download episodes from the PowerShell Podcast.

    .DESCRIPTION
    This function fetches the RSS feed of the PowerShell Podcast and lists all episodes.

    .EXAMPLE
    # List all episodes
    Get-PSPodcast

    .INPUTS
    None

    .OUTPUTS
    System.Management.Automation.PSCustomObject

    .LINK
    https://powershellpodcast.podbean.com/

    #>

    [CmdletBinding()]
    param ()

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $Verbose = $false
        }
        $invokeRestMethodSplat = @{
            Uri            = 'https://feed.podbean.com/powershellpodcast/feed.xml'
            ProgressAction = 'SilentlyContinue'
            ErrorAction    = 'SilentlyContinue'
            Verbose        = $Verbose
        }
        $feed = Invoke-RestMethod @invokeRestMethodSplat
        if ($null -eq $feed) {
            Write-Error "Failed to retrieve the podcast feed $($invokeRestMethodSplat.Uri)."
            return
        }
    }
    process {

        $feed | ForEach-Object {
            $duration = [timespan]::new(0,0,$_.duration) # hrs,min,sec

            [pscustomobject]@{
                episode  = [int]$_.episode
                pubDate  = '{0:yyyy-MM-dd}' -f [datetime]$_.pubDate
                duration = $duration.ToString()
                title    = $_.title[0]
            }
        }
    }
}
