# AI Shell presentation script

## Slide 1 - Title slide

Welcome and introduction

## Slide 2 - Lots of command line interfaces throughout history

- How many have you used?
- GUIs took over - but now there's a resurgence of command line interfaces
- Command-line scripting for automation

## Slide 3 - Command-line tools are hard to use

- 1000s of commands
- Inconsistent syntaxes across tools
- Hard to remember commands and parameters
- Hard to find the right tool for the job

## Slide 4 - AI Shell to the rescue

- Interactive and cross-platform
- Modular support for different AI agents
- Integrates with PowerShell
- Supports MCPs for agentic scenarios
- 2 agents included
- Can create and add your own agents - see documentation
- Extended demo to come

## Slide 5 - Install AI Shell

- Open docs pages from link
- Review requirements
- Importance of matching versions of `aish` and module

## MAIN DEMO

Start AI Shell

- Run WT.exe to get correct version of terminal

  ```powershell
  Start-AIShell
  ```

Explain the PS module

- Select the **openai-agent**
  - this is the same as using ChatGPT on the web
  - No special training for the model
  - System prompt in config: Told it to be a PowerShell expert

    ```powershell
    Get-Command -Module AIShell | %{ Get-Alias -Definition $_.Name}
    ```

  - airun -> Invoke-AICommand
    - Used by MCP to run commands - not meant for end user
  - askai -> Invoke-AIShell
  - fixit -> Resolve-Error
  - aish -> Start-AIShell

Prompt - Using PowerShell, how do I get the files less than 20MB in the MyFiles folder of the current directory

- I could copy/paste the result from the answer
- AI Shell doesn't automatically run the code
- You have time to review and understand it before executing

  ```sh
  /code post #or Ctrl+dd (hotkey)
  ```

Prompt - get a list of running services that include Microsoft in the name

- Ctrl+dd (hotkey) or `/code post`

## Slide 6 - OpenAI Agent

- Show docs for agent

## Slide 7 - Azure AI Foundry

- Deploy your own instances of GPT-4o
- Train it with your own data

## DEMO 2 - More features

Metalanguage

```sh
/help
/agent list
```

Show configuration

```sh
/agent config
```

## Slide 8 - Copilot in Azure agent

- Free to use in your Azure subscription
- Trained with your own Azure docs
- No configuration needed

## Slide 9 - Copilot in Azure everywhere

Microsoft Copilot in Azure is available from everywhere you want to work with Azure.

- Azure Portal
- AI Shell
- GitHub Copilot for Azure in Visual Studio Code

You get the same Copilot for Azure capabilities in every location.

## Slide 10 - MCP support

MCP tools enable AI agents to access external tools and services to enhance their capabilities and
provide more accurate responses. MCPs can integrate with various APIs, databases, and other
resources, allowing agents to retrieve real-time information and perform complex tasks.

- Open the docs link

Now back to Demos

## DEMO 3 - Copilot in Azure

Switch to Azure agent

```sh
/agent use azure
@azure
```

Sign into Azure

- Login commands cache creds in different stores
- Login to both for best results
- May need to switch Tenants and refresh token if expired

  ```powershell
  az login --tenant 888d76fa-54b2-4ced-8ee5-aac1585adee7
  connect-azaccount -Tenant 888d76fa-54b2-4ced-8ee5-aac1585adee7 # refresh token
  ```

Prompt - How do I create an Azure key vault?

- notice the az commands
- Prompt - how do I do that in PowerShell?

Prompt - create a new resource group and an app insights instance using PowerShell

```sh
/replace
```

Ask a conceptual question - What is App Insights?

- Show answer
- Not just useful for code

## DEMO - Advanced commands

Run commands from PowerShell

```powershell
gmo document* |
  Invoke-AIShell 'These are the modules I have loaded. What are these used for?' -Agent openai-gpt
```

Switch agents

```sh
@openai-gpt
```

Resolve errors

```powershell
Get-Process | Count
Resolve-Error
askai 'is there a way to suppress the error?'
askai -post
```

More advanced queries

```powershell
askai 'list the files larger than 20mb in the myfiles folder of the current directory'
askai -post
Get-Service | Where-Object { $_.DisplayName -like "*Microsoft*" -and $_.Status -eq "Running" }
```

## Slide 11 & 12 - Call to action & Thanks for coming

- Download and install AI Shell
- Fill out feedback survey
