# Beginning PowerShell Workshop

## Introduction (Jason)

- Introduce the team
- Why PowerShell Matters
  - Management and Automation at scale
  - Sacred promise
  - Optimizing the user, not the product. (empowering you)
- Don't fear the Shell (Jason/Jason)
  - TODO: Jason's old song and dance routine
  - A shell and a scripting language
  - Native commands
  - Cmdlet - Verb-Noun
  - Aliases - shortcuts
  - Scripts

## Getting Started (Jason/Jeff/Sean - Docs)

- Where does PowerShell run? (Linux, macOS, Windows, Azure Cloud Shell)
- How do I get PowerShell
  - Why its not already in Windows
  - GitHub/Store/WinGet (link)
  - Docs: Install docs (link)
- Launching PowerShell
  - Launch Console - just Show
  - Launch on Mac - preferred
  - Launch in Terminal - preferred
    - Brief: Multi versions - CloudShell - WSL

## The Help System (Jason/Sean)

- Updatable Help
- Get-Help, Help, Man
- Dynamic Help F1, alt-a, alt-h (less important than F1)
- Discoverability with the Help system
  - The Process - Discover then Dig
  - Examples:
    - Get-Help <noun>
    - Get-Help <verb>
    - Get-Help cmdlet -detailed
    - Get-Help cmdlet -Examples
    - Get-Help cmdlet -Full
    - Get-Help cmdlet -Online
    - Get-Help cmdlet -ShowWindow
- Real-world
  - Examples of discovering and solving
    - Get-WinEvent
    - Get-Service -Name bits
    - Stop-Service
    - Start-Service
    - Get-AdComputer

  - The other help system About_
- Understanding Syntax
  - Parameter Sets
  - What does all this syntax mean?

## Extending the shell (Jeff/Sean)

- Finding and Adding Modules
  - Install Jeff's teaching module
- PowerShell Gallery
- Discovering new commands
  - Get-Command -Module <Module>
  - Get-Help <noun>
- Optimizing Shell Experience (Jason/Sean)
  - See new ShellUX docs
  - Predictors
    - SecretManagement
    - Crescendo - No, Just concept if asked.
  - PSGet V2/v3 ??
    - Find-PSResource, Install-PSResource

## The Pipeline: Connecting commands (Jeff)

- What's the pipe and what does it do?
  - How things are passed
  - Examples
    - Get-service -name bits
    - Get-Service -Name bits | Stop-Service
    - Get-Service | Stop-Service
- Brief mention of parameter binding
  - Point to docs
- Exporting/Importing CSV's
- Exporting/Importing CLIXML
- Exporting/Importing JSON
  - Example: Compare-Object on Processes
- Printers and files
- Displaying information in a GUI
  - Out-GridView
- Making a webpage of Information
- Cmdlets that kill
  - -WhatIf
  - -Confirm

## Objects for the Admin (Jeff/Jason)

TODO: Update WMI examples to use CimCmdlets

- Object across the pipeline
  - How they flow
  - Get-Member
- Getting the information you need
  - Type Name
  - Methods
  - Properties
- Sorting Objects
  - Examples
    - Get-ChildItem | Get-Member #Property list
    - Get-ChildItem -Path c: | Sort-Object -property Length -Descending
    - Get-Process | Sort-Object -Property cpu -Descending
- Selecting Objects
  - Examples
    - Get-Service | Select-Object -Property Name, Status
    - Get-Process | Select-Object -Property Name, ID, VM, PM
    - Trick: Get-Command -Module <module> | Sort-Object -property noun | Get-Help | Select-Object -Property Name, Synopsis
- Measuring and Grouping
  - Get-Command -Module <module> | Measure-Object
  - Group-Object example
- Custom Properties
  - Examples
    - Get-Service | Select-Object -Property Name, status , @{n='MyState';e={$_.Status}}
    - Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='c:'" | Select-Object -Property Freespace
    - Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='c:'" | Select-Object -Property @{n='FreeGB';e={$_.Freespace /1GB as [int]}}
- Filtering data
  - Comparison operators
    - Examples
  - Where-Object
    - Examples
  - -Filter
  - Filter left - Format right!
- Methods - when no cmdlet exists
  - Brief introduction into Methods
  - What if Stop-Service and Start-Service didn't exist?
  - Examples
    - Get-Service -Name bits | Get-Member #Use GM
    - Get-Service -Name bits | Foreach{$_.stop()}
    - $var=Get-Service bits #Vars in more detail later
    - $var.Start()

## Overview of Docs (Sean)

- Overview of Docs platform features
  - Versions
  - Search & Filter
  - Conceptual vs reference
  - Navigation
- Structure of Docs and other docsets
  - Module browser
  - Utility modules
  - DSC
  - Community section
- Contributing

## Automation in Scale - Remoting (Jeff/Jason)

- Overview of Remoting
- How to enable Remoting (WinRM/SSH)
  - Not-Demo: Enabling PSRemoting (doc Link)
  - Not-Demo: group Policy - (doc link)
  - Not Demo: SSH setup - (doc link)Group Policy
- One-To-One
  - Enter-PSSession
    - Windows to Windows
    - Mac to Windows
- One-To-Many
  - Invoke-Command
  - Using sessions with Invoke-Command
- ? Real-World Web server deployment
  - Example:
    - Deploy web-server to multiple computers
    - Deploy a website
- Creating automation scripts
- Getting command from anywhere - Implicit Remoting

## Introducing scripting and toolmaking (Jeff/Sean)

- Setting up your scripting tools and environment
  - Execution Policy
  - VS Code vs ISE
  - PowerShell extension
  - PSScriptAnalyzer (mention VS Code experience only)
- Variables: A place to store stuff
- Making commands repeatable
  - Example - Get-CimInstance -class Win32_LogicalDisk
  - Example - Get-CimInstance -class win32_Bios
- Adding Parameters to your script
- Documenting your script
- Turning your script into a Advanced function
  - Example
    - Param block with variables
    - Adding the properties to a hashtable
    - Creating your own object
- How about a Module?
  - A place to store your commands

## Closing

- Resources
  - Jeff's Pluralsight content
- Next steps
- Call to action
