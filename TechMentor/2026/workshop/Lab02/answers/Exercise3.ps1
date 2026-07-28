<#######################################################################################
# Lab02
# - Add argument completion for the Name parameter of Remove-Alias
#   Tab completion should show the aliases currently defined in the session
#######################################################################################>

$aliasSimple = {
    param ($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    Get-Alias | Where-Object { $_.Name -like "$wordToComplete*" }
}
Register-ArgumentCompleter -ParameterName 'Name' -CommandName 'Remove-Alias' -ScriptBlock $aliasSimple


$aliasAdvanced = {
    param ($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    $aliases = Get-Alias | Select-Object -Property Name, Definition |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Definition)
        }
    $aliases | Where-Object { $_.CompletionText -like "$wordToComplete*" }
}
Register-ArgumentCompleter -ParameterName 'Name' -CommandName 'Remove-Alias' -ScriptBlock $aliasAdvanced

