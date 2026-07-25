# Windows PowerShell 5.1 compatibility demo

$wmiPrinters = Get-WmiObject -Class Win32_Printer
$cimPrinters = Get-CimInstance -ClassName Win32_Printer

Write-Host 'WMI Printer[2]'
$wmiPrinters[2]
Write-Host 'CIM Printer[2]'
$cimPrinters[2] | Format-List

Write-Host 'WMI Printer Methods'
$wmiPrinters | Get-Member -MemberType Method

Write-Host 'CIM Printer Methods'
$cimPrinters | Get-Member -MemberType Method

$wmiMethods = $wmiPrinters | Get-Member -MemberType Method |
    Sort-Object -Property Name | Select-Object Name

$cimMethods = Get-CimClass -ClassName Win32_Printer |
    Select-Object -ExpandProperty CimClassMethods |
    Sort-Object -Property Name |
    Select-Object Name

Write-Host 'Compare WMI vs CIM Printer Methods'
$compareObjectSplat = @{
    Property         = 'Name'
    ReferenceObject  = $wmiMethods
    DifferenceObject = $cimMethods
    IncludeEqual     = $true
}
Compare-Object @compareObjectSplat

Write-Host 'Set default printer using WMI'
$wmiPrinters[2].SetDefaultPrinter()
Write-Host 'Set default printer using CIM'
Invoke-CimMethod -InputObject $cimPrinters[2] -MethodName SetDefaultPrinter
