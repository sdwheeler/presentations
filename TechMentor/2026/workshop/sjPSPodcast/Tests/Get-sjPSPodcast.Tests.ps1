BeforeAll {
    $moduleRoot = Split-Path -Path $PSScriptRoot -Parent
    $getChildItemSplat = @{
        Path    = Join-Path -Path $moduleRoot -ChildPath 'Output\sjPSPodcast'
        Filter  = 'sjPSPodcast.psd1'
        Recurse = $true
    }
    $manifestPath = Get-ChildItem @getChildItemSplat |
        Sort-Object -Property FullName -Descending |
        Select-Object -First 1 -ExpandProperty FullName

    if (-not $manifestPath) {
        throw 'Built module not found under Output\sjPSPodcast. Run the Build task first (Invoke-Build Build).'
    }

    Import-Module -Name $manifestPath -Force

    $script:fixtureFeed = @(
        [PSCustomObject]@{
            episode     = 239
            title       = @('Episode 239 Title', 'Episode 239 Title')
            pubDate     = 'Mon, 20 Jul 2026 08:00:00 -0600'
            duration    = 2746
            summary     = [PSCustomObject]@{ '#cdata-section' = 'Summary for episode 239.' }
            description = [PSCustomObject]@{ '#cdata-section' = 'Full description for episode 239.' }
            enclosure   = [PSCustomObject]@{
                url    = 'https://mcdn.podbean.com/mf/web/xyz/episode_239.mp3'
                length = '109877288'
                type   = 'audio/mpeg'
            }
            guid        = [PSCustomObject]@{ '#text' = 'guid-239'; isPermaLink = 'false' }
            link        = 'https://powershellpodcast.podbean.com/e/episode-239/'
        },
        [PSCustomObject]@{
            episode     = 100
            title       = @('Episode 100 Title', 'Episode 100 Title')
            pubDate     = 'Mon, 01 Jan 2024 08:00:00 -0600'
            duration    = 1800
            summary     = [PSCustomObject]@{ '#cdata-section' = 'Summary for episode 100 about Azure automation.' }
            description = [PSCustomObject]@{ '#cdata-section' = 'Full description for episode 100 about Azure.' }
            enclosure   = [PSCustomObject]@{
                url    = 'https://mcdn.podbean.com/mf/web/xyz/episode_100.mp3'
                length = '50000000'
                type   = 'audio/mpeg'
            }
            guid        = [PSCustomObject]@{ '#text' = 'guid-100'; isPermaLink = 'false' }
            link        = 'https://powershellpodcast.podbean.com/e/episode-100/'
        }
    )
}

AfterAll {
    Remove-Module -Name sjPSPodcast -Force -ErrorAction SilentlyContinue
}

Describe 'Get-sjPSPodcast' {
    BeforeEach {
        Mock -ModuleName sjPSPodcast Invoke-RestMethod { $script:fixtureFeed }
    }

    It 'returns one sjPSPodcast.Episode object per feed item' {
        $result = Get-sjPSPodcast
        $result.Count | Should -Be 2
        $result[0].PSTypeNames | Should -Contain 'sjPSPodcast.Episode'
    }

    It 'sorts episodes by Number ascending, so the most recent episode prints last' {
        $result = Get-sjPSPodcast
        $result[0].Number | Should -Be 100
        $result[1].Number | Should -Be 239
    }

    It 'maps the feed fields correctly' {
        $result = Get-sjPSPodcast | Where-Object Number -EQ 239
        $result.Title | Should -Be 'Episode 239 Title'
        $result.Url | Should -Be 'https://mcdn.podbean.com/mf/web/xyz/episode_239.mp3'
        $result.Duration | Should -Be ([timespan]::new(0, 0, 2746))
        $result.FileSize | Should -Be 109877288
        $result.Guid | Should -Be 'guid-239'
        $result.Description | Should -Be 'Summary for episode 239.'
    }

    It 'writes an error and returns nothing when the feed cannot be retrieved' {
        Mock -ModuleName sjPSPodcast Invoke-RestMethod { throw 'network failure' }

        $result = Get-sjPSPodcast -ErrorAction SilentlyContinue -ErrorVariable err
        $result | Should -BeNullOrEmpty
        $err | Should -Not -BeNullOrEmpty
    }
}
