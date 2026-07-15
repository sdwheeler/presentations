function Get-PSPodcast {
    <#
    .SYNOPSIS
    Retrieve and optionally download episodes from the PowerShell Podcast.

    .DESCRIPTION
    This function fetches the RSS feed of the PowerShell Podcast, lists episodes,
    and allows downloading specific episodes by episode number or by a search string.

    .PARAMETER EpisodeNumber
    The episode number to download. If specified, the function will download this episode.

    .PARAMETER OutFolder
    The folder where the episode will be saved. The folder must exist.

    .PARAMETER Find
    A search string to filter episodes by title or description.

    .EXAMPLE
    # List all episodes
    Get-PSPodcast

    .EXAMPLE
    # List episodes with "Azure" in the title or description
    Get-PSPodcast -Find Azure

    .EXAMPLE
    # Download episode number 50 to the current directory
    Get-PSPodcast -EpisodeNumber 50

    .EXAMPLE
    # Download episode number 50 to a specified folder
    Get-PSPodcast -EpisodeNumber 50 -OutFolder "C:\Podcasts"

    .NOTES
    The output folder must exist.

    .LINK
    https://powershellpodcast.podbean.com/

    #>

    [CmdletBinding(DefaultParameterSetName = 'ByEpisode')]
    param (
        [Parameter(Position = 0, ParameterSetName = 'ByEpisode', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Number')]
        [int]$EpisodeNumber,

        [Parameter(Position = 0, ParameterSetName = 'ByKeyword', ValueFromPipeline)]
        [string]$Find,

        [Parameter(ParameterSetName = 'ByEpisode', HelpMessage = 'The output folder must exist.')]
        [Parameter(ParameterSetName = 'ByKeyword', HelpMessage = 'The output folder must exist.')]
        [ValidateScript({ Test-Path $_ -PathType Container },
            ErrorMessage = 'OutFolder must be a valid directory path.')]
        [ValidateNotNullOrWhiteSpace()]
        [string]$OutFolder
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Verbose')) {
            $Verbose = $false
        }
        if (-not $PSBoundParameters.ContainsKey('ProgressAction')) {
            $ProgressAction = 'Continue'
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
        $epiUrl = $null
        $list = $feed

        if ($EpisodeNumber -gt 0) {
            $list = $feed | Where-Object { $_.episode -eq $EpisodeNumber }
        } elseif ($Find -ne '') {
            $list = $feed | Where-Object {
                $_.title -match [regex]::Escape($Find) -or
                $_.description.'#cdata-section' -match [regex]::Escape($Find)
            }
        }

        $list | ForEach-Object {
            $dparts = $_.duration -split ':'
            if ($dparts.Count -eq 2) { $hour = 0 } else { $hour = $dparts[0] }
            $epiUrl = $_.enclosure.url
            $fileExtension = ($epiUrl -split '\.')[-1]

            [pscustomobject]@{
                episode  = [int]$_.episode
                pubDate  = '{0:yyyy-MM-dd}' -f [datetime]$_.pubDate
                duration = '{0:D2}:{1:D2}:{2:D2}' -f $hour, $dparts[-2], $dparts[-1]
                title    = $_.title[0]
            }
            if ($OutFolder -ne '') {
                $outfile = Join-Path $OutFolder "PowerShell_Podcast_$($_.episode).$fileExtension"
                Write-Verbose "Downloading episode $($_.episode) to $outfile"
                Invoke-RestMethod -Uri $epiUrl -OutFile $outfile -Verbose:$Verbose -ProgressAction:$ProgressAction
            }
        }
    }
}
