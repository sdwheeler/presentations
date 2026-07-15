function Find-PSPodcastEpisode {
    <#
    .SYNOPSIS
    Retrieve and optionally download episodes from the PowerShell Podcast.

    .DESCRIPTION
    This function fetches the RSS feed of the PowerShell Podcast and returns a list of episodes that
    match the specified search string. The command matches terms in the title and description of the
    episode.

    .PARAMETER Find
    A search string to filter episodes by title or description. This can be a regular expression.

    .EXAMPLE
    # List episodes with "Azure" in the title or description
    Find-PSPodcastEpisode -Find Azure

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSCustomObject

    .LINK
    https://powershellpodcast.podbean.com/

    #>

    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [SupportsWildcards()]
        [string]$Find
    )

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
        $feed |
            Where-Object { $_.title -match $Find -or
                $_.description.'#cdata-section' -match $Find } |
            ForEach-Object {
                $duration = [timespan]::new(0, 0, $_.duration) # hrs,min,sec

                [pscustomobject]@{
                    episode     = [int]$_.episode
                    pubDate     = '{0:yyyy-MM-dd}' -f [datetime]$_.pubDate
                    duration    = $duration.ToString()
                    title       = $_.title[0]
                }
            }
    }
}
