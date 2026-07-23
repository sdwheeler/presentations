function ConvertTo-sjPSPodcastEpisode {
    <#
    .SYNOPSIS
    Converts a raw PowerShell Podcast feed item into an sjPSPodcast.Episode object.

    .DESCRIPTION
    Invoke-RestMethod flattens most of the feed's itunes: elements cleanly, but a
    few need help: title comes back as a two-element array (rss title + duplicate
    itunes:title), description is a CDATA node, and guid/enclosure carry their
    values as attributes plus a #text/child property. This function normalizes
    all of that into one PSCustomObject shape.

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
        $description = $InputObject.summary
        if ([string]::IsNullOrWhiteSpace($description)) {
            $description = $InputObject.description.'#cdata-section'
        }

        $title = $InputObject.title
        if ($title -is [array]) {
            $title = $title[0]
        }

        [PSCustomObject]@{
            PSTypeName  = 'sjPSPodcast.Episode'
            Number      = [int]$InputObject.episode
            Title       = $title
            PubDate     = [datetime]$InputObject.pubDate
            Duration    = [timespan]::new(0, 0, [int]$InputObject.duration)
            Description = $description
            Url         = $InputObject.enclosure.url
            FileSize    = [int64]$InputObject.enclosure.length
            MimeType    = $InputObject.enclosure.type
            Guid        = $InputObject.guid.'#text'
            Link        = $InputObject.link
        }
    }
}
