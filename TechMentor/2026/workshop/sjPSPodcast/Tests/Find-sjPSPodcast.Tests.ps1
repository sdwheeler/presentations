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

Describe 'Find-sjPSPodcast' {
    BeforeEach {
        Mock -ModuleName sjPSPodcast Invoke-RestMethod { $script:fixtureFeed }
    }

    It 'filters by Number' {
        $result = Find-sjPSPodcast -Number 100
        $result.Number | Should -Be 100
    }

    It 'filters by Title substring' {
        $result = Find-sjPSPodcast -Title '239'
        $result.Number | Should -Be 239
    }

    It 'filters by Description substring' {
        $result = Find-sjPSPodcast -Description Azure
        $result.Number | Should -Be 100
    }

    It 'filters by After date' {
        $result = Find-sjPSPodcast -After (Get-Date -Date '2025-01-01')
        $result.Number | Should -Be 239
    }

    It 'filters by Before date' {
        $result = Find-sjPSPodcast -Before (Get-Date -Date '2025-01-01')
        $result.Number | Should -Be 100
    }

    It 'combines multiple filters with AND' {
        $result = Find-sjPSPodcast -Title '239' -Description Azure
        $result | Should -BeNullOrEmpty
    }
}
