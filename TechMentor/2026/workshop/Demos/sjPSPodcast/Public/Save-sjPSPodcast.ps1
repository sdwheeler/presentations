function Save-sjPSPodcast {
  <#
    .SYNOPSIS
    Downloads an episode of the PowerShell Podcast.

    .DESCRIPTION
    Downloads the audio file for one episode of the PowerShell Podcast. Accepts
    episode objects piped from Get-sjPSPodcast or Find-sjPSPodcast, or an episode
    number on its own (in which case the episode is looked up via Find-sjPSPodcast).

    .PARAMETER Number
    The episode number to download.

    .PARAMETER Title
    The episode title, used to build the downloaded file name. Supplied
    automatically when piped in from Get-sjPSPodcast/Find-sjPSPodcast.

    .PARAMETER Url
    The audio file URL to download. Supplied automatically when piped in from
    Get-sjPSPodcast/Find-sjPSPodcast; resolved via Find-sjPSPodcast otherwise.

    .PARAMETER Destination
    The folder to download the episode into. Defaults to the current directory.
    Created automatically if it doesn't exist.

    .PARAMETER PassThru
    Emit a FileInfo for the downloaded file.

    .EXAMPLE
    Save-sjPSPodcast -Number 40

    Downloads episode 40 to the current directory.

    .EXAMPLE
    Find-sjPSPodcast -Number 121 | Save-sjPSPodcast -PassThru

    Downloads episode 121 to the current directory and emits a FileInfo for the downloaded file.

    .EXAMPLE
    Find-sjPSPodcast -Title Azure | Save-sjPSPodcast -Destination C:\Podcasts

    Downloads every episode with "Azure" in the title to C:\Podcasts.

    .OUTPUTS
    System.IO.FileInfo (only with -PassThru)

    .LINK
    https://powershellpodcast.podbean.com/
  #>

  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
    [int]$Number,

    [Parameter(ValueFromPipelineByPropertyName)]
    [string]$Title,

    [Parameter(ValueFromPipelineByPropertyName)]
    [string]$Url,

    [Parameter()]
    [string]$Destination = (Get-Location).Path,

    [Parameter()]
    [switch]$PassThru
  )

  process {
    if (-not $Url) {
      $episode = Find-sjPSPodcast -Number $Number
      if (-not $episode) {
        Write-Error -Message "Episode $Number was not found in the feed."
        return
      }
      $Title = $episode.Title
      $Url = $episode.Url
    }

    $extension = ($Url -split '\.')[-1]
    $safeTitle = ($Title -replace '[\\/:*?"<>|]', '').Trim()
    $fileName = 'PowerShellPodcast_Ep{0}_{1}.{2}' -f $Number, $safeTitle, $extension
    $outFile = Join-Path -Path $Destination -ChildPath $fileName

    if ($PSCmdlet.ShouldProcess($outFile, 'Download episode')) {
      if (-not (Test-Path -LiteralPath $Destination -PathType Container)) {
        New-Item -ItemType Directory -Force -Path $Destination | Out-Null
      }

      $invokeWebRequestSplat = @{
        Uri = $Url
        OutFile = $outFile
      }
      Invoke-WebRequest @invokeWebRequestSplat

      if ($PassThru) {
        Get-Item -LiteralPath $outFile
      }
    }
  } # end process block
} # end function Save-sjPSPodcast
