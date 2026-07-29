# PlatyPS Preview1 Release

https://devblogs.microsoft.com/powershell/announcing-platyps-100-preview1/

## Introduction

**PlatyPS** is the primary tool for creating the PowerShell help displayed using `Get-Help`.
PowerShell help files are stored in an XML format known as
[Microsoft Assistance Markup Language][06] (MAML). Prior to **PlatyPS**, the help files were hand
authored using complex tool chains. [Markdown][05] is widely used in the open source community,
supported by many editors including [Visual Studio Code][01], and easier to author. **PlatyPS**
simplifies the process by allowing you to write the help files in Markdown and then converted to
MAML.

- **platyPS v0.14.2** is the current version of PlatyPS that's used to create PowerShell help files
  in Markdown format.
- **Microsoft.PowerShell.PlatyPS** is the new version of PlatyPS that includes several improvements:
  - Provides a more accurate  description of a PowerShell cmdlet and its parameters
  - Increased performance - processes 1000s of Markdown files in seconds
  - Creates an object model of the help file that you can manipulate in memory
  - Provides cmdlets that you can chain together to perform complex operations

Our main goal for this release is to address long standing issues, add more schema driven
features, and improve validity checking along with performance. This release is a substantial
rewrite with all new cmdlets. If you have scripts that use the older version of PlatyPS, you must
rewrite them to use the new cmdlets.

In this Preview release, we focused on:

- Re-write in C# leveraging [markdig][04] for parsing Markdown.
- New Markdown schema that includes all elements needed for `Get-Help`, plus information that was
  previously unavailable.
- The new cmdlets produce objects, supporting chaining cmdlets for complex operations.
- Full serialization to YAML to support our publishing pipeline.
- Automatic conversion of existing Markdown to the new object model.
- Export of the object model to Markdown, Yaml, and MAML.

## Links

- [Docs](https://learn.microsoft.com/powershell/module/microsoft.powershell.platyps)
- [Gallery](https://www.powershellgallery.com/packages/Microsoft.PowerShell.PlatyPS)
- [Repo](https://github.com/PowerShell/platyPS)
