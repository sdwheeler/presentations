function ConvertTo-sjPSPodcastEpisode {
  <#
    .SYNOPSIS
    Converts a raw PowerShell Podcast feed item into an sjPSPodcast.Episode object.

    .DESCRIPTION
    Invoke-RestMethod flattens most of the feed's itunes: elements cleanly, but a
    few need help: title comes back as a two-element array (rss title + duplicate
    itunes:title), description/summary are CDATA nodes (see Get-sjPSPodcastNodeText),
    and guid/enclosure carry their values as attributes plus a #text/child property.
    This function normalizes all of that into one PSCustomObject shape.

    itunes:summary is used for Description (plain text) rather than description or
    content:encoded, both of which carry the same content wrapped in raw HTML markup
    (<ul><li><a href=...>) that isn't appropriate for a console-displayed property.

    .PARAMETER InputObject
    A single raw feed item, as returned by Invoke-RestMethod against
    https://feed.podbean.com/powershellpodcast/feed.xml.

    .OUTPUTS
    PSCustomObject (PSTypeName sjPSPodcast.Episode)
  #>

  [CmdletBinding()]
  param (
    [Parameter(Mandatory, ValueFromPipeline)]
    [object]$InputObject
  )

  process {
    $description = Get-sjPSPodcastNodeText -Node $InputObject.summary
    if ([string]::IsNullOrWhiteSpace($description)) {
      $description = Get-sjPSPodcastNodeText -Node $InputObject.description
    }

    $title = $InputObject.title
    if ($title -is [array]) {
      $title = $title[0]
    }

    [PSCustomObject]@{
      PSTypeName = 'sjPSPodcast.Episode'
      Number = [int]$InputObject.episode
      Title = $title
      PubDate = [datetime]$InputObject.pubDate
      Duration = [timespan]::new(0, 0, [int]$InputObject.duration)
      Description = $description
      Url = $InputObject.enclosure.url
      FileSize = [int64]$InputObject.enclosure.length
      MimeType = $InputObject.enclosure.type
      Guid = $InputObject.guid.'#text'
      Link = $InputObject.link
    }
  } # end process block
} # end function ConvertTo-sjPSPodcastEpisode
