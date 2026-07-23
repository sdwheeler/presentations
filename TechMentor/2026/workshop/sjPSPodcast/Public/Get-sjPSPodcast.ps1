function Get-sjPSPodcast {
    <#
    .SYNOPSIS
    Lists episodes of the PowerShell Podcast.

    .DESCRIPTION
    Fetches the PowerShell Podcast RSS feed and returns every episode as an
    sjPSPodcast.Episode object, newest first. The feed is always fetched fresh;
    nothing is cached between calls.

    .EXAMPLE
    Get-sjPSPodcast

    Lists every episode.

    .EXAMPLE
    Get-sjPSPodcast | Select-Object -First 5

    Lists the five most recent episodes.

    .OUTPUTS
    sjPSPodcast.Episode

    .LINK
    https://powershellpodcast.podbean.com/
    #>
    [CmdletBinding()]
    param ()

    $invokeRestMethodSplat = @{
        Uri         = 'https://feed.podbean.com/powershellpodcast/feed.xml'
        ErrorAction = 'Stop'
    }

    try {
        $feed = Invoke-RestMethod @invokeRestMethodSplat
    } catch {
        Write-Error -Message "Failed to retrieve the podcast feed '$($invokeRestMethodSplat.Uri)': $_"
        return
    }

    $feed | ConvertTo-sjPSPodcastEpisode | Sort-Object -Property Number -Descending
}
