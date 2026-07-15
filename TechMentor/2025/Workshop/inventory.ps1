function Get-Inventory {
    param(
        [string]$ComputerName = $env:COMPUTERNAME
    )
    Write-Host "Gathering inventory information..." -ForegroundColor Green
    $computerSystem = Get-CimInstance win32_computersystem -ComputerName $ComputerName |
        Select-Object name, SystemFamily, Model
    $bios = Get-CimInstance win32_bios -ComputerName $ComputerName |
        Select-Object serialnumber, SMBIOSBIOSVersion
    $operatingSystem = Get-CimInstance win32_operatingSystem -ComputerName $ComputerName |
        Select-Object Caption, Version, InstallDate

    return @{
        ComputerSystem = $computerSystem
        BIOS = $bios
        OperatingSystem = $operatingSystem
    }
}

function Get-Detail {
param(
    [Parameter(Mandatory)]
    [ValidateSet("Low", "Average", "High")]
    [string[]]$Detail
)
$Detail
}