function Get-sjPSPodcastNodeText {
  <#
    .SYNOPSIS
    Extracts plain text from a feed field that Invoke-RestMethod may return as a
    plain string or as an XmlElement wrapping a #cdata-section or #text child.

    .DESCRIPTION
    itunes:summary and description both wrap their text in a CDATA section, which
    Invoke-RestMethod exposes as an XmlElement rather than a simple string. Coercing
    that XmlElement straight to [string] (e.g. via IsNullOrWhiteSpace) does not
    return its text -- it falls back to the element's own tag name, since the
    element has no simple content of its own. This unwraps the real text instead.

    .PARAMETER Node
    The raw property value to extract text from.
  #>

  [CmdletBinding()]
  param (
    [Parameter(ValueFromPipeline)]
    [object]$Node
  )

  process {
    if ($null -eq $Node) {
      return
    }
    if ($Node -is [string]) {
      return $Node
    }
    if ($Node.PSObject.Properties.Match('#cdata-section').Count -gt 0) {
      return $Node.'#cdata-section'
    }
    if ($Node.PSObject.Properties.Match('#text').Count -gt 0) {
      return $Node.'#text'
    }
  }
} # end function Get-sjPSPodcastNodeText
