# TechMentor @ Microsoft HQ 2025 - PowerShell Hands-On Labs

## Lab 1: Introduction to PowerShell

### Install PowerShell

1. Install PowerShell 7 (if you can)

   **Answer:**

   Follow the instructions to install PowerShell 7 on your system. You can find the installation
   guide for your operating system in the documentation:
   [Install PowerShell on Windows, Linux, and macOS][51]

   If you are running Windows, Windows PowerShell 5.1 is already installed by default, but you can
   install PowerShell 7 alongside it. On windows the preferred way to install PowerShell 7 is using
   WinGet.

1. Get help for a command before help is installed:

   ```powershell
   Get-Help Get-Command -Full
   ```

   **Answer:**

   Before help is installed, you will see a basic description of the command and its syntax. There
   are no descriptions or examples. The REMARKS section contains the following message:

   ```
   Get-Help cannot find the Help files for this cmdlet on this computer. It is displaying only partial help.
       -- To download and install Help files for the module that includes this cmdlet, use Update-Help.
   ```

### Update help

1. Run `Update-Help` to install the latest help on your computer.

   ```powershell
   Update-Help -Force
   ```

   **Answer:**

   This requires that the shell is running with elevated privileges (use the Run as Administrator
   option). On Windows, you an get error message about failing to download help for specific
   modules. This is a known issue for those modules.

   ```
   Update-Help: Failed to update Help for the module(s) 'ConfigDefenderPerformance, Dism, Get-NetView, Kds, Microsoft.PowerShell.ThreadJob, NetQos, Pester, PKI, Whea, WindowsUpdate' with UI culture(s) {en-US} : One or more errors occurred. (Response status code does not indicate success: 404 (The requested content does not exist.).). English-US help content is available and can be installed using: Update-Help -UICulture en-US.
   ```

1. Get help after help is installed, run:

   ```powershell
   Get-Help Get-Command -Full
   ```

   **Answer:**

   Notice the difference in the amount of information. You know you have the installed the help when
   you see the full description, syntax, parameters, examples, and additional information in the
   output.

### Learning resources

- [What is PowerShell?][60]
- [What is a command shell?][65]
- [Installing PowerShell on Windows][52]
- [PowerShell Releases][04]
- [Install PowerShell on Windows, Linux, and macOS][51]
- [PowerShell/PowerShell Releases][04]
- [Update-Help][27]
- [about_Updatable_Help][22]

PowerShell 7 runs side-by-side with Windows PowerShell 5.1
- [Migrating from Windows PowerShell 5.1 to PowerShell 7][68]
- [Differences between Windows PowerShell 5.1 and PowerShell 7.x][67]
- [Release history of modules and cmdlets][66]
- [about_Windows_PowerShell_Compatibility][23]

---

## Lab 2 - Command discovery and problem solving

### Command discovery

1. Can you find any cmdlets capable of converting other cmdlets' output into HTML?

   **Answer:**

   ```powershell
   Get-Command -Noun HTML
   Get-Help HTML
   ```

1. How many cmdlets are available for working with processes? (Hint: remember that cmdlets all use a
   singular noun.)

   **Answer:**

   ```powershell
   Get-Command -Noun process | Select-Object -Property Name

   Name
   ----
   Debug-Process
   Get-Process
   Start-Process
   Stop-Process
   Wait-Process
   ```

1. Is there a way to shutdown a remote computer?

   **Answer:**

   ```powershell
   Stop-Computer  -ComputerName Server1
   ```

### Problem solving

1. How would you find the Background Intelligent Transfer Service?

   **Answer:**

   ```powershell
   Get-Service -Name bits
   Get-Service -DisplayName Background*
   ```

1. What's the current status of the Background Intelligent Transfer Service?

   **Answer:**

   ```powershell
   Get-Service -Name bits

   Status   Name               DisplayName
   ------   ----               -----------
   Running  bits               Background Intelligent Transfer Service
   ```

1. Is the Background Intelligent Transfer Service set to start automatically?

   **Answer:**

   ```powershell
   Get-Service -Name bits | Select-Object -Property Start*Type
   ```

   In Windows PowerShell 5.1, you see output similar to:

   ```
   StartType
   ---------
   Automatic
   ```

   In PowerShell 7, you see output similar to:

   ```
             StartupType StartType
             ----------- ---------
   AutomaticDelayedStart Automatic
   ```

1. How would you stop the Background Intelligent Transfer Service?

   **Answer:**

   There are several ways to stop the service:

   ```powershell
   Stop-Service -Name bits
   Get-Service -Name bits | Stop-Service
   (Get-Service -Name bits).Stop()
   ```

### Learning resources

- [Discover PowerShell][49]
- [Get-Help][25]
- [about_Command_Syntax][06]
- [Get-Command][24]
- [Get-Member][37]
- [Get-Verb][38]
- [Stop-Computer][31]
- [Get-Service][30]
- [Stop-Service][32]
- [Select-Object][39]
- [How to use the PowerShell documentation][50]

---

## Lab 3 - Modules & Pipeline

### Modules

1. What modules are available on your system?

   **Answer:**

   ```powershell
   Get-Module -ListAvailable
   ```

1. What is the latest version of the Pester module available in the PowerShell Gallery?

   **Answer:**

   There are several ways to find the latest version of the Pester module:

   - Search for the module in the PowerShell Gallery
   - Use the `Find-Module` cmdlet from the PowerShellGet module

     ```powershell
     Find-Module -Name Pester

     Version       Name     Repository    Description
     -------       ----     ----------    -----------
     5.7.1         Pester   PSGallery     Pester provides a framework for running …

     Find-Module -Name Pester -AllowPrerelease

     Version       Name     Repository    Description
     -------       ----     ----------    -----------
     6.0.0-alpha5  Pester   PSGallery     Pester provides a framework for running …

     ```

   - Use the `Find-PSResource` cmdlet from the Microsoft.PowerShell.PSResourceGet module

     ```powershell
     Find-PSResource -Name Pester

     Name   Version Prerelease Repository Description
     ----   ------- ---------- ---------- -----------
     Pester 5.7.1              PSGallery  Pester provides a framework for running BDD style Tests to execute and validate P…

     Find-PSResource -Name Pester -Prerelease

     Name   Version Prerelease Repository Description
     ----   ------- ---------- ---------- -----------
     Pester 6.0.0   alpha5     PSGallery  Pester provides a framework for running BDD style Tests to execute and validate P…
     ```

### Using the pipeline

1. What's difference between the following commands?

   ```powershell
   Get-ChildItem -File | Format-Table Name, Length | Sort-Object Length
   Get-ChildItem -File | Format-Table Name, Length | Get-Member
   Get-ChildItem -File | Sort-Object Length | Format-Table Name, Length
   ```

   **Answer:**

   - The first command results in an error because `Format-Table` does not output objects that can
     be sorted.
   - The second command uses `Get-Member` to display information about the objects returned by
     `Format-Table`. You will see objects of the following types:

     ```
     TypeName: Microsoft.PowerShell.Commands.Internal.Format.FormatStartData
     TypeName: Microsoft.PowerShell.Commands.Internal.Format.GroupStartData
     TypeName: Microsoft.PowerShell.Commands.Internal.Format.FormatEntryData
     TypeName: Microsoft.PowerShell.Commands.Internal.Format.GroupEndData
     TypeName: Microsoft.PowerShell.Commands.Internal.Format.FormatEndData
     ```

   - The third command sorts the objects by their length before passing them to `Format-Table`,
     which works as expected.

1. What properties are available on the objects returned by `Get-Process`? How can you display all
   of them?

   **Answer:**

   The `Get-Member` cmdlet shows you the properties of the objects returned by `Get-Process`. Also,
   you can use the `Select-Object` cmdlet to display all properties and their values.

   ```powershell
   Get-Process | Get-Member -MemberType Property
   Get-Process | Select-Object -Property *
   ```

1. Run the following command and compare the output:

   ```powershell
   Get-Process pwsh
   Get-Process pwsh | Format-Table
   Get-Process pwsh | Format-List
   Get-Process pwsh | Select-Object -Property *
   ```

   **Answer:**

   The output of the first two commands is identical. By default, the formatting system in
   PowerShell outputs process objects in a table format. When you run these command in PowerShell 7,
   notice that some of the column headers are displayed in italics. This indicates that the column
   names don't match the actual property names.

   The third command formats the output as a list. Notice that you see different properties in the
   output of the third command compared to the first two. The last command uses `Select-Object` to
   display all properties of the process object, which includes properties that are not shown by
   default in the table or list formats.

### Learning resources

- [about_Modules][10]
- [about_PSModulePath][17]
- [Get-Module][26]
- [Install-Module (PowerShellGet)][42]
- [Find-Module (PowerShellGet)][41]
- [Install-PSResource][34]
- [Find-PSResource][33]
- [about_Pipelines][12]
- [Get-ChildItem][28]
- [Sort-Object][40]
- [Format-Table][36]
- [Format-List][35]
- [about_Parameter_Binding][11]
- [Visualize parameter binding][53]

---

## Lab 4 - Providers, Functions, & Scripts

### Create a function

Create a function called `Get-AssetInfo` that retrieves information about the computer system and
BIOS. The function should accept a parameter for the computer name, defaulting to the local computer
if none is provided. It should return a custom object with properties such as **ComputerName**,
**Manufacturer**, **Model**, **BIOSVersion**, and **SerialNumber**.

**Answer:**

Your code is probably different. This example shows how you implement advanced features like
pipeline support and creating custom objects for output. You should always try to create objects for
output instead of trying to output formatted strings. That way, your function can be used in
pipelines and with other cmdlets that expect objects as input.

```powershell
function Get-AssetInfo {

    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName
    )

    begin {
        if ($null -eq $ComputerName) {
            $ComputerName = $env:COMPUTERNAME
        }
    }

    process {
        foreach ($name in $ComputerName) {
            $CompSys = Get-CimInstance Win32_ComputerSystem -ComputerName $name
            $SysBios = Get-CimInstance Win32_BIOS -ComputerName $name
            $SysEncl = Get-CimInstance Win32_SystemEnclosure -ComputerName $name
            $SysDisk = Get-CimInstance Win32_DiskDrive -ComputerName $name
            $SysProc = Get-CimInstance Win32_Processor -ComputerName $name

            [pscustomobject]@{
                ComputerName = $CompSys.Name
                Manufacturer = $CompSys.Manufacturer
                Model = $CompSys.Model
                BIOSVersion = $SysBios.BIOSVersion
                AssetTag = $SysEncl.SMBIOSAssetTag
                SerialNumber = $SysBios.SerialNumber
                TotalRAM = '{0:N2} GB' -f ($CompSys.TotalPhysicalMemory / 1GB)
                DiskSize = $SysDisk.Size | %{ '{0:N2} GB' -f ($_ / 1GB)}
                Processor = ($SysProc.Name -join ', ')
            }
        }
    }

}
```

### Learning resources

- [about_Providers][15]
- [Get-PSDrive][29]
- [about_Function_Provider][07]
- [about_Registry_Provider][18]
- [about_Functions][08]
- [about_Functions_Advanced_Parameters][09]
- [about_PSCustomObject][16]
- [about_Command_Precedence][05]

---

## Lab 5 - Create a profile

1. Create a profile script

   **Answer:**

   You can use the following command to create an empty profile script in the proper location:

   ```powershell
   if (!(Test-Path -Path $PROFILE)) {
     New-Item -ItemType File -Path $PROFILE -Force
   }
   ```

   This command creates the file and any parent directories that don't exist. You can then open the
   profile script in your favorite text editor and add your commands.

1. Add the function you created in Lab 4
1. Configure PSReadLine key bindings for the following keys:

   | Key chord |        Function         |
   | --------- | ----------------------- |
   | `Enter`   | `ValidateAndAcceptLine` |
   | `Alt+a`   | `SelectCommandArgument` |
   | `F1`      | `ShowCommandHelp`       |
   | `Alt+h`   | `ShowParameterHelp`     |

The final profile script might look like this:

```powershell
<#
    My Profile Script
    Updated: 2025-08-06
#>
#----------------------------------
#region Define helper functions
function Get-AssetInfo {

    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$ComputerName
    )

    begin {
        if ($null -eq $ComputerName) {
            $ComputerName = $env:COMPUTERNAME
        }
    }

    process {
        foreach ($name in $ComputerName) {
            $CompSys = Get-CimInstance Win32_ComputerSystem -ComputerName $name
            $SysBios = Get-CimInstance Win32_BIOS -ComputerName $name
            $SysEncl = Get-CimInstance Win32_SystemEnclosure -ComputerName $name
            $SysDisk = Get-CimInstance Win32_DiskDrive -ComputerName $name
            $SysProc = Get-CimInstance Win32_Processor -ComputerName $name

            [pscustomobject]@{
                ComputerName = $CompSys.Name
                Manufacturer = $CompSys.Manufacturer
                Model = $CompSys.Model
                BIOSVersion = $SysBios.BIOSVersion
                AssetTag = $SysEncl.SMBIOSAssetTag
                SerialNumber = $SysBios.SerialNumber
                TotalRAM = '{0:N2} GB' -f ($CompSys.TotalPhysicalMemory / 1GB)
                DiskSize = $SysDisk.Size | %{ '{0:N2} GB' -f ($_ / 1GB)}
                Processor = ($SysProc.Name -join ', ')
            }
        }
    }

}
#endregion
#----------------------------------
#region Configure PSReadLine
Set-PSReadLineKeyHandler -Key Enter -Function ValidateAndAcceptLine
Set-PSReadLineKeyHandler -Key Alt+a -Function SelectCommandArgument
Set-PSReadLineKeyHandler -Key F1 -Function ShowCommandHelp
Set-PSReadLineKeyHandler -Key Alt+h -Function ShowParameterHelp
#endregion
#----------------------------------
```

### Learning resources

- [about_Profiles][13]
- [about_Prompts][14]
- [Get-PSReadLineOption][43]
- [Set-PSReadLineOption][45]
- [Set-PSReadLineKeyHandler][44]
- [Using tab-completion in the shell][57]
- [Using predictors in PSReadLine][59]
- [Using dynamic help][56]
- [Customizing your shell environment][55]
- [Using PSReadLine key handlers][58]

---

## Lab 6 - PowerShell Remoting

There is no Lab 6 in this workshop.

### Learning resources

- [about_Remote][19]
- [about_Remote_Requirements][20]
- [about_Remote_Troubleshooting][21]
- [Running Remote Commands][62]
- [Using WS-Management (WSMan) Remoting in PowerShell][64]
- [PowerShell Remoting Over SSH][63]
- [PowerShell Remoting FAQ][61]
- [about_Windows_PowerShell_Compatibility][23]
- [PowerShell 7 module compatibility in Windows Server 2025][70]

---

## Other useful links

History of PowerShell

- [The Monad Manifesto][48]

Learning PowerShell

- [PowerShell 101 book by Mike F. Robbins][54]
- [What's New in PowerShell-Docs for 2025][46]
- [What's New in PowerShell 7.5][69]

Presenter content

- [Sean's blog and presentations][72]
- [Steven's blog and presentations][03]

Community resources

- [PowerShell community support resources][47]
- PowerShell Virtual User Group
  - [Slack][02]
  - [Discord][01]
- [The PowerShell Podcast][71]

<!-- link references -->
[01]: https://aka.ms/psdiscord
[02]: https://aka.ms/psslack
[03]: https://blog.stevenjudd.com/
[04]: https://github.com/PowerShell/PowerShell/releases
[05]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_command_precedence
[06]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_command_syntax
[07]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_function_provider
[08]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_functions
[09]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters
[10]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_modules
[11]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_parameter_binding
[12]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_pipelines
[13]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_profiles
[14]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_prompts
[15]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_providers
[16]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_pscustomobject
[17]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_psmodulepath
[18]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_registry_provider
[19]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_remote
[20]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_remote_requirements
[21]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_remote_troubleshooting
[22]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_updatable_help
[23]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_windows_powershell_compatibility
[24]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/get-command
[25]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/get-help
[26]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/get-module
[27]: https://learn.microsoft.com/powershell/module/microsoft.powershell.core/update-help
[28]: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-childitem
[29]: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-psdrive
[30]: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/get-service
[31]: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/stop-computer
[32]: https://learn.microsoft.com/powershell/module/microsoft.powershell.management/stop-service
[33]: https://learn.microsoft.com/powershell/module/microsoft.powershell.psresourceget/find-psresource
[34]: https://learn.microsoft.com/powershell/module/microsoft.powershell.psresourceget/install-psresource
[35]: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/format-list
[36]: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/format-table
[37]: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/get-member
[38]: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/get-verb
[39]: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/select-object
[40]: https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/sort-object
[41]: https://learn.microsoft.com/powershell/module/powershellget/find-module?view=powershellget-2.x
[42]: https://learn.microsoft.com/powershell/module/powershellget/install-module?view=powershellget-2.x
[43]: https://learn.microsoft.com/powershell/module/psreadline/get-psreadlineoption
[44]: https://learn.microsoft.com/powershell/module/psreadline/set-psreadlinekeyhandler
[45]: https://learn.microsoft.com/powershell/module/psreadline/set-psreadlineoption
[46]: https://learn.microsoft.com/powershell/scripting/community/2025-updates
[47]: https://learn.microsoft.com/powershell/scripting/community/community-support
[48]: https://learn.microsoft.com/powershell/scripting/developer/monad-manifesto
[49]: https://learn.microsoft.com/powershell/scripting/discover-powershell
[50]: https://learn.microsoft.com/powershell/scripting/how-to-use-docs
[51]: https://learn.microsoft.com/powershell/scripting/install/installing-powershell
[52]: https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows
[53]: https://learn.microsoft.com/powershell/scripting/learn/deep-dives/visualize-parameter-binding
[54]: https://learn.microsoft.com/powershell/scripting/learn/ps101/00-introduction
[55]: https://learn.microsoft.com/powershell/scripting/learn/shell/creating-profiles
[56]: https://learn.microsoft.com/powershell/scripting/learn/shell/dynamic-help
[57]: https://learn.microsoft.com/powershell/scripting/learn/shell/tab-completion
[58]: https://learn.microsoft.com/powershell/scripting/learn/shell/using-keyhandlers
[59]: https://learn.microsoft.com/powershell/scripting/learn/shell/using-predictors
[60]: https://learn.microsoft.com/powershell/scripting/overview
[61]: https://learn.microsoft.com/powershell/scripting/security/remoting/powershell-remoting-faq
[62]: https://learn.microsoft.com/powershell/scripting/security/remoting/running-remote-commands
[63]: https://learn.microsoft.com/powershell/scripting/security/remoting/ssh-remoting-in-powershell
[64]: https://learn.microsoft.com/powershell/scripting/security/remoting/wsman-remoting-in-powershell
[65]: https://learn.microsoft.com/powershell/scripting/what-is-a-command-shell
[66]: https://learn.microsoft.com/powershell/scripting/whats-new/cmdlet-versions
[67]: https://learn.microsoft.com/powershell/scripting/whats-new/differences-from-windows-powershell
[68]: https://learn.microsoft.com/powershell/scripting/whats-new/migrating-from-windows-powershell-51-to-powershell-7
[69]: https://learn.microsoft.com/powershell/scripting/whats-new/what-s-new-in-powershell-75
[70]: https://learn.microsoft.com/powershell/windows/module-compatibility
[71]: https://powershellpodcast.podbean.com/
[72]: https://sdwheeler.github.io/seanonit/docs/
