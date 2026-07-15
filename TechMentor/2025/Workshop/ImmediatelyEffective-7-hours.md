# Become immediately effective in PowerShell

## Section 1: Introduction to PowerShell - 52 min

### Intro - Jason (Sean, Steven) - 7 min

- Who are we
- Why PowerShell?
  - PowerShell is a cross-platform (Windows, Linux, and macOS) automation and configuration
    tool/framework that works well for DevOps, IT Pros, and developers.
  - It's built on the .NET platform and provides a rich scripting language.
  - PowerShell is designed to help you automate tasks and manage systems more efficiently.
- What is PowerShell?
  - Command shell - run any native command
  - Scripting language - automate tasks
- What are we going to cover
  - Installation
  - Command discovery & Help system
  - Modules, command precedence, and providers
  - The pipeline
  - Functions & scripts
  - Shell features
  - PowerShell remoting
  - Q&A

### Installing PowerShell 7 - Sean - 15 min

- Why is it not in Windows? - Jason
- You can use PowerShell 5.1 for this class
- Show the docs
  - [Install PowerShell on Windows, Linux, and macOS][08]
  - [Migrating from Windows PowerShell 5.1 to PowerShell 7][11]
  - [Differences between Windows PowerShell 5.1 and PowerShell 7.x][10]
  - [Release history of modules and cmdlets][09]
  - [about Windows PowerShell Compatibility][07]
- Show the releases
  - [PowerShell/PowerShell Releases][04]
  - Expand the Github Assets
- Winget Install
- PowerShell 7 runs side-by-side with Windows PowerShell 5.1
  - Doesn't remove the version nag at startup

### Command discovery & Help system - Steven - 15 min

- Get-Command
- Get-Member
- Get-Verb
- Get-Help - Intro only - Don't show how to use it in detail

### Lab 1 - Command discovery & Help system - 15 min

- [Lab 01](Lab-01.md)
  - Install PowerShell 7 (if you can)
  - Start your preferred version of PowerShell
  - Update-Help - Do it now

## Section 2: Help, docs, and community - 45 min

### Using the Help system - Jason - 20 min

- Get-Help, help, man
- Discoverability with the Help system
  - The Process - Discover then Dig
  - Examples:
    - Get-Help <noun>
    - Get-Help <verb>
    - Get-Help cmdlet -Detailed
    - Get-Help cmdlet -Examples
    - Get-Help cmdlet -Full
    - Get-Help cmdlet -Online
    - Get-Help cmdlet -ShowWindow
  - The other help system About_

- Understanding Syntax
  - Chihuahuas & binkies
    - Parameter Sets
    - What does all this syntax mean?
      - Get-help Get-Service
      - Get-Help Get-Process then Stop-Process

### Getting Help & Docs - Sean - 10 min

Online documentation

- How to find help

Other help options - [Community Resources][05]

- Discord/Slack, StackOverflow, Spiceworks, PowerShell.org
  - PDQ Discord - https://discord.gg/YfuJWQmT
  - Reddit - r/PowerShell - not recommended (toxic)

PowerShell blogs

### Lab 2 - Command discovery and problem solving - Lab 15min

- [Lab 02](Lab-02.md)

## Section 3: Modules, Command precedence, & Providers - 50 min

### Modules - Extending the shell (Sean) - 15 min

Finding modules to install - Sean

- Module Browser
- PowerShell Gallery
  - Find-PSResourceGet

Installing modules

- PS5.1 PowerShellGet bootstrapping
  - Install-Module Microsoft.PowerShell.PSResourceGet
  - Install-PSResource PSReadLine
  - user install scope
- Galleries

Importing modules

- Auto-import

Discovering new commands

- Get-Command -Module <Module>
- (Get-Command -Module <module>).Count
  - Explain member access to get the count

### Command precedence

- Alias
- Function
- Cmdlet (see Cmdlet name resolution)
- External executable files (including PowerShell script files)

Demo

```powershell
Set-Alias -Name ipconfig -Value Get-ChildItem
Get-Command ipconfig -All
function ipconfig {
    Write-Host "This is a fake ipconfig function"
}
```

There are no `Remove-Alias` or `Remove-Function` cmdlets.

```powershell
del alias:ipconfig
del function:ipconfig
```

### Providers

- What is a provider?
  - A way to access data stores in PowerShell
  - File system, registry, environment variables, etc.
  - cd HKLM:\SYSTEM\CurrentControlSet\Services\BITS
  - dir Cert:\LocalMachine\My\

## Section 4: The pipeline

### The Pipeline: Connecting commands - Steven - 20 min

- What's the pipe and what does it do?
  - How things are passed
- Sorting, selecting, filtering, and formatting
  - Filter left, format right
- Difference between Out-*, Write-*, and Format-* cmdlets
  - Out-* - Output to something other than the console
    - Special case - Out-Default - sends to formatting system
  - Write-* - Writes a PowerShell output stream
    - Special case - Write-Host - writes to the console first
  - Format-* - Formats the output for display (format objects)

### Lab 3 - Pipeline - 15 min

- [Lab 03](Lab-03.md)

## Section 5 - Functions & scripts - 55 min

### From one-liners to functions to scripts

Execution Policy

- What is it?
- Windows only

Reasons for using scripts or functions

- Reusability & Sharing
- Shortcut your life
  - Batch commands into a single unit
  - Wrap commands to provide default parameter values
- Move from batch commands to tools (scripts vs. batch)
  - Add extended logic
  - Improve error handling
  - Demo in functions section

Script Demo

- Create a simple batch script

Variables and scope: A place to store stuff

- Variable syntax ${scope:var}
- Using pscustomobject

Scopes

- Scope types: Global, Local, Script, Private
  - copy on create

Scope demo - copy on create

```powershell
$var = "I'm global"
function Test-Scope {
    "`$var = $var"
    $var = "Now I'm local"
    "`$var = $var"
}
Test-Scope
$var
```

Functions

- What is a scriptblock?
  - A function is a named scriptblock
- begin, process, end, clean blocks
- Function demo
  - Convert the batch script to a function
- Dot-sourcing and scope
  - profiles
  - VSCode/ISE - always test outside of IDE

Advanced functions

- Turning your script into a Advanced function
  - Add extended logic
  - Improve error handling
  - CmdletBinding()

Demo - setup for lab

- Objects and CIM examples
- Invoke-RestMethod for RSS feed

Sharing your code

- Creating a module - simple rename to .psm1
- Comment-based help (only if there is time)

### Lab 4 - Create a function to retrieve asset information - 15 min

- [Lab 04](Lab-04.md)
  - Show CIM commands and how to get the properties from a variable

## Section 6: Shell features - 50 min

Intelligent shell - Sean

- Features
  - Dynamic Help F1, alt-a, alt-h (less important than F1)
  - PSReadLine
  - Tab completion - you can create your own
  - Syntax highlighting
  - Predictors
  - https://learn.microsoft.com/powershell/scripting/learn/shell/optimize-shell

Profiles

- Putting all together in your Profile
  - What is the Profile?
  - Where are they?
  - Why so many?
  - Configuring the features

### Break & lab

- [Lab 05](Lab-05.md)
  - Create a profile script that configures your shell

## Section 7: PowerShell remoting

- TODO - Need VMs in Azure
- Overview of Remoting
  - One-To-One
    - Enter-PSSession
      - Windows to Windows
      - Mac to Windows
  - One-To-Many
    - Invoke-Command
  - Reusable sessions
    - New-PSSession
  - Using sessions with Invoke-Command
  - Deserialized objects
- Windows Compatibility feature
- Enable-PSRemoting
  - Must be run as admin to enable and connect
  - JEA - mention for security
- Show docs - Sean
- Demo - Real-World Web server deployment
  - Deploy web-server to multiple computers
  - Deploy a website

## Section 8 - Ask us anything - time remaining

## Wrap up - 5 min
