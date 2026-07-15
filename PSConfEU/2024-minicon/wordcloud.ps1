$newWordCloudSplat = @{
    Path = '.\contributors4.svg'
    Typeface = 'Consolas'
    ImageSize = '1280x720'
    BackgroundColor = 'd8e1e9'
    WordSizes = @{
        '@MartinGC94 (59)' = 59
        '@CarloToso (31)' = 31
        '@ArmaanMcleod (15)' = 15
        Completion = 55
        Webcmdlets = 35
        General = 38
        Path = 4
        ErrorHandling = 9
        Json = 6
        Performance = 3
        NewCommands = 2
    }
}
New-WordCloud @newWordCloudSplat

1..10 | %{
    $newWordCloudSplat.Path = '.\contributors-{0}.svg' -f $_
    New-WordCloud @newWordCloudSplat
}