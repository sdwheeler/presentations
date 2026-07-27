#-------------------------------------------------------
function Get-AsciiValue {
    [CmdletBinding(DefaultParameterSetName='ByChar')]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByChar')]
        [ValidateLength(1,1)]
        [string]$Char,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'ByValue')]
        [ValidateRange(0, 255)]
        [int]$Byte,

        [Parameter(Mandatory, ParameterSetName = 'ByRange')]
        [ValidateSet('Control', 'Printable', 'Extended')]
        [string]$Range
    )
    begin {
        $ascii = Import-Csv $PSScriptRoot\ascii.csv
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            'ByChar'  { $ascii[([int]($char[0]))] }
            'ByValue' { $ascii[$byte] }
            'ByRange' { $ascii | Where-Object Collection -eq $Range }
        }
    }
}
#-------------------------------------------------------
# ValidatePattern
# ValidateScript