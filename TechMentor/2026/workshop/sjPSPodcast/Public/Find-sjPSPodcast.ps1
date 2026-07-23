function Find-sjPSPodcast {
    <#
    .SYNOPSIS
    Searches episodes of the PowerShell Podcast.

    .DESCRIPTION
    Lists episodes of the PowerShell Podcast that match one or more filters.
    All supplied filters are combined with AND. Title and Description accept
    wildcards; a plain word/phrase is treated as a substring match.

    .PARAMETER Number
    One or more episode numbers to match.

    .PARAMETER Title
    A title to match. Plain text matches as a substring; include * or ? for a
    literal wildcard pattern.

    .PARAMETER Description
    A word or phrase to match in the episode description. Plain text matches as
    a substring; include * or ? for a literal wildcard pattern.

    .PARAMETER After
    Only include episodes published on or after this date.

    .PARAMETER Before
    Only include episodes published on or before this date.

    .EXAMPLE
    Find-sjPSPodcast -Title Azure

    Lists episodes whose title contains "Azure".

    .EXAMPLE
    Find-sjPSPodcast -Description DSC -After 2025-01-01

    Lists episodes published since 2025-01-01 whose description mentions "DSC".

    .OUTPUTS
    sjPSPodcast.Episode

    .LINK
    https://powershellpodcast.podbean.com/
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [int[]]$Number,

        [Parameter()]
        [SupportsWildcards()]
        [string]$Title,

        [Parameter()]
        [SupportsWildcards()]
        [string]$Description,

        [Parameter()]
        [datetime]$After,

        [Parameter()]
        [datetime]$Before
    )

    $titlePattern = if ($Title -match '[*?]') { $Title } else { "*$Title*" }
    $descriptionPattern = if ($Description -match '[*?]') { $Description } else { "*$Description*" }

    Get-sjPSPodcast | Where-Object {
        (-not $PSBoundParameters.ContainsKey('Number') -or $_.Number -in $Number) -and
        (-not $PSBoundParameters.ContainsKey('Title') -or $_.Title -like $titlePattern) -and
        (-not $PSBoundParameters.ContainsKey('Description') -or $_.Description -like $descriptionPattern) -and
        (-not $PSBoundParameters.ContainsKey('After') -or $_.PubDate -ge $After) -and
        (-not $PSBoundParameters.ContainsKey('Before') -or $_.PubDate -le $Before)
    }
}
