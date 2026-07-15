# PowerShell toolmaking tips: Build reusable tools worth sharing

## Abstract

Learn how to turn everyday PowerShell one-liners and batch scripts into robust, reusable tools and
published modules.

Attendees will learn to design advanced functions with parameter validation, pipeline support,
argument completion, and comment-based help. They will also learn to organize code into
well-structured modules with manifests, manage public and private functions, and publish packages to
a PowerShell repository.

This workshop is not for beginners. This is for people with some experience writing basic scripts
that want to take them to the next level. We will cover a lot of information with lots of
interactive demos. Bring your laptop to take notes and follow along with the code we provide.

Preferred software configuration

-	PowerShell 7 installed on any supported OS
-	Windows PowerShell 5.1 will work for most examples
-	Visual Studio Code with the PowerShell extension installed


## Introduction

Introduction

- Who are we
- Prerequisites
  - Some experience writing PowerShell scripts
  - VS Code with PowerShell extension
  - PowerShell 7 (or 5.1)

Goals/Outline

- Turn one-liners and scripts into functions
- Add advanced features
  - Pipeline input
  - Parameter validation
  - Argument completion
- Create user documentation
  - Comment-based help
- Package functions into modules
  - Module structure and manifest
  - Public vs private functions
- Publish modules to a PSRepository

## Foundational concepts

Execution Policy

- What is it?
- Windows only

### Command precedence

- Alias
- Function
- Cmdlet (see Cmdlet name resolution)
- External executable files (including PowerShell script files)

Demo

```powershell
Set-Alias -Name ipconfig -Value Get-ChildItem
function ipconfig { Write-Host "This is a fake ipconfig function" }
Get-Command ipconfig -All
```

There are no `Remove-Alias` or `Remove-Function` cmdlets.

```powershell
del alias:ipconfig
del function:ipconfig
```

### Scripts & functions

Why use scripts or functions?

- Reusability & Sharing
- Shortcut your life
  - Batch commands into a single unit
  - Wrap commands to provide default parameter values
- Move from batch commands to tools (scripts vs. batch)
  - Add extended logic
  - Improve error handling
  - Demo in functions section

### Variables and scope: A place to store stuff

- Variable syntax ${scope:var}
- Using pscustomobject
- Scope types: Global, Local, Script, Private
  - copy on create
- Dot-sourcing and scope
  - profiles
  - VSCode/ISE - always test outside of IDE

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

## From one-liners to functions to scripts

Evolution of a tool (outline only - examples later)

- Complex one-liner
- Wrap one-liner in a script
  - Add parameters
  - Add error handling
- Convert script to function
  - Add advanced features
    - Pipeline input
    - Parameter validation
    - Argument completion
  - Add comment-based help
- Convert PS1 file of functions to module
  - Rename to PSM1
  - Add module manifest
  - Add private/public functions
  - Add type/format files

Script Demo

- Create a simple batch script

### Functions

- What is a scriptblock?
  - A function is a named scriptblock
- begin, process, end, clean blocks
- Function demo
  - Convert the batch script to a function

Advanced functions

- Turning your script into a Advanced function
  - Add extended logic
  - Improve error handling
  - CmdletBinding()

Demo - setup for lab

- Objects and CIM examples
- Invoke-RestMethod for RSS feed

### Parameter attributes & validation

- [CmdletBinding()]
- Parameter attributes
  - [Parameter()]
    - Mandatory
    - Position
    - ValueFromPipeline
    - ValueFromPipelineByPropertyName
  - Validation attributes
    - [ValidateSet()]
    - [ValidateScript()]
    - [ValidateNotNullOrEmpty()]

### Quick overview pipeline input

- ByValue vs ByPropertyName
- Trace-Command

### Argument completers

- Different ways to do argument completion
  - Register-ArgumentCompleter
  - ArgumentCompleter attribute
  - Enum type parameters
  - [ValidateSet()]
  - Script-based vs Class-based

### Comment-based help

- Why?
- Quick overview of Help system
- Syntax and pitfalls
  - location in code
  - comment styling - `#` vs `<# #>`
  - markup and formatting
  - Singletons, multiline, single instance

## Module design philosophies

Structure

- Public vs private functions
- Monolithic vs multiple files
- Type files
- Format files
- Help file
- Other resources

Module manifest

- New-ModuleManifest
- Why?

Commands

- Commands are single purpose
- Get/Set/Update/Remove - CRUD operations https://wikipedia.org/wiki/Create,_read,_update_and_delete
- Use approved verbs
- Noun consistency
- Parameter consistency for pipelining
- Error handling
  - Write-Error vs throw
  - Try/catch/finally
  - $ErrorActionPreference
  - ShouldProcess/WhatIf/Confirm

## Publishing modules

- PSResourceGet
- Register-PSResourceRepository local filesystem
- Other repository options
- Publish-Module/Publish-PSResource
