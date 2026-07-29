function FormatDate {
    param (
        [Parameter(Mandatory = $true)]
        [DateTime]$Date
    )

    return '{0:d.MM.yyyy}' -f $Date
}