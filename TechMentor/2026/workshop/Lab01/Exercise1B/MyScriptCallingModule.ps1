param (
    [DateTime] $EventDate = '08/03/2026',
    [string]   $Presenter = 'Sean',
    [string]   $Subject   = 'how to work with PowerShell modules'
)

Import-Module $PSScriptRoot\MyModule -PassThru -Force

$MyParams = @{
    EventDate = $EventDate
    Presenter = $Presenter
    Subject   = $Subject
}

Get-MyDemoMessage @MyParams  | Show-MyDemoEventMessage