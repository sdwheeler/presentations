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
}

AfterAll {
    Remove-Module -Name sjPSPodcast -Force -ErrorAction SilentlyContinue
}

Describe 'Save-sjPSPodcast' {
    BeforeEach {
        Mock -ModuleName sjPSPodcast Invoke-WebRequest {
            param($Uri, $OutFile)
            New-Item -ItemType File -Path $OutFile -Force | Out-Null
        }
    }

    It 'downloads using the pipeline-supplied Url without hitting the feed' {
        Mock -ModuleName sjPSPodcast Invoke-RestMethod { throw 'Invoke-RestMethod should not be called' }

        $episode = [PSCustomObject]@{
            PSTypeName = 'sjPSPodcast.Episode'
            Number     = 239
            Title      = 'Episode 239 Title'
            Url        = 'https://mcdn.podbean.com/mf/web/xyz/episode_239.mp3'
        }

        $episode | Save-sjPSPodcast -Destination 'TestDrive:\' -PassThru | Out-Null

        Should -Invoke -CommandName Invoke-WebRequest -ModuleName sjPSPodcast -Times 1 -ParameterFilter {
            $Uri -eq 'https://mcdn.podbean.com/mf/web/xyz/episode_239.mp3'
        }
    }

    It 'resolves the Url via Find-sjPSPodcast when only Number is supplied' {
        Mock -ModuleName sjPSPodcast Invoke-RestMethod {
            @(
                [PSCustomObject]@{
                    episode     = 239
                    title       = @('Episode 239 Title', 'Episode 239 Title')
                    pubDate     = 'Mon, 20 Jul 2026 08:00:00 -0600'
                    duration    = 2746
                    summary     = 'Summary'
                    description = [PSCustomObject]@{ '#cdata-section' = 'Full description' }
                    enclosure   = [PSCustomObject]@{
                        url    = 'https://mcdn.podbean.com/mf/web/xyz/episode_239.mp3'
                        length = '109877288'
                        type   = 'audio/mpeg'
                    }
                    guid        = [PSCustomObject]@{ '#text' = 'guid-239'; isPermaLink = 'false' }
                    link        = 'https://powershellpodcast.podbean.com/e/episode-239/'
                }
            )
        }

        Save-sjPSPodcast -Number 239 -Destination 'TestDrive:\'

        Should -Invoke -CommandName Invoke-WebRequest -ModuleName sjPSPodcast -Times 1
    }

    It 'builds a sanitized file name from Number and Title' {
        Mock -ModuleName sjPSPodcast Invoke-RestMethod { throw 'Invoke-RestMethod should not be called' }

        $episode = [PSCustomObject]@{
            PSTypeName = 'sjPSPodcast.Episode'
            Number     = 5
            Title      = 'A/B: Weird "Title"?'
            Url        = 'https://example.test/file.mp3'
        }

        $file = $episode | Save-sjPSPodcast -Destination 'TestDrive:\' -PassThru

        $file.Name | Should -Be 'sjPSPodcast_Ep5_AB Weird Title.mp3'
    }
}
