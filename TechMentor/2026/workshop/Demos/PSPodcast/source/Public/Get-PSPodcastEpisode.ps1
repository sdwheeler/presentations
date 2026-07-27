function Get-PSPodcastEpisode {
    <#
    .SYNOPSIS
    Retrieve and optionally download episodes from the PowerShell Podcast.

    .DESCRIPTION
    This function fetches the RSS feed of the PowerShell Podcast and returns the specified episode.

    .PARAMETER Episode
    The episode number to fetch.

    .PARAMETER OutFolder
    The folder where the episode will be saved. The folder must exist.

    .EXAMPLE
    # Download episode number 50 to the current directory
    Get-PSPodcastEpisode -Episode 50

    .EXAMPLE
    # Download episode number 50 to a specified folder
    Get-PSPodcastEpisode -Episode 50 -OutFolder "C:\Podcasts"

    .INPUTS
    System.Int32

    .OUTPUTS
    System.Management.Automation.PSCustomObject

    .OUTPUTS
    System.IO.FileInfo

    .NOTES
    The output folder must exist.

    .LINK
    https://powershellpodcast.podbean.com/

    #>

    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Number')]
        [int]$Episode,

        [Parameter(Position = 1, HelpMessage = 'Enter path of an existing folder.')]
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
        $feed |
            Where-Object { $_.episode -eq $Episode } |
            ForEach-Object {
                $duration = [TimeSpan]::new(0,0,$_.duration) # hrs,min,sec
                $epiUrl = $_.enclosure.url
                $fileExtension = ($epiUrl -split '\.')[-1]

                $ep = [pscustomobject]@{
                    episode  = [int]$_.episode
                    pubDate  = '{0:yyyy-MM-dd}' -f [datetime]$_.pubDate
                    duration = $duration.ToString()
                    title    = $_.title[0]
                    description = $_.description.'#cdata-section'
                }
                if ($OutFolder -ne '') {
                    $outfile = Join-Path $OutFolder "PowerShell_Podcast_$($_.episode).$fileExtension"
                    Write-Verbose "Downloading episode $($_.episode) to $outfile"
                    Invoke-RestMethod -Uri $epiUrl -OutFile $outfile -Verbose:$Verbose -ProgressAction:$ProgressAction
                    Get-ChildItem -LiteralPath $outfile
                } else {
                    $ep
                }
            }
    }
}
