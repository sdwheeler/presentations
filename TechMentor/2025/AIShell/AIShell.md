# Demo

## Start AI Shell

- explain the PS module
- select the openai-agent
  - this is the same as using ChatGPT on the web
  - No special training
  - Told it to be a PowerShell expert

Prompt - Using PowerShell, how do I get the files less than 20MB in the MyFiles folder of the current directory

- I could copy/paste the result from the answer
- We don't automatically run the code so you have time to review and understand it before executing
- /code post or Ctrl+dd (hot- key)

Prompt - get a list of running services that include Microsoft in the name

- /code post or Ctrl+dd (hotkey)

## Shell capabilities

- 2 agents included
- Can create and add your own agents - see documentation
- Extended demo to come

## Install

- Show docs
- Use script
- Caveats & requirements

## Interact with the AI Shell from PowerShell

- Get-Command -Module AIShell
  - Invoke-AICommand (airun)
    - not meant for end user
    - Used by MCP to run commands
  - Invoke-AIShell
  - Resolve-Error
  - Start-AIShell
  - gcm -Module AIShell | %{ get-alias -Definition $_.name}

### Metalanguage

- Show /help
- /agent list

### OpenAI Agent

- Get-Process | Count
- Resolve-Error
- /agent config
- Show docs for agent

### About Azure Foundry

- Deploy your own instances of GPT-4o
- Train it with your own data

### Copilot in Azure agent

- Free to use in your Azure subscription
- No configuration needed
  - require `az login` or `connect-azaccount` before you start (preferably both)
- /agent use azure or @azure
  - need to refresh token - connect-azaccount -Tenant 888d76fa-54b2-4ced-8ee5-aac1585adee7

Prompt - How do I create a key vault?

- notice the az commands
- how do I do that in PowerShell

Prompt - create a new resource group and an app insights instance using PowerShell

- /replace

Prompt - What is App Insights?

### Advanced commands

- gmo document*| Invoke-AIShell 'These are the modules I have loaded. What are these used for?' -Agent openai-gpt
- @openai-gpt
- askai 'list the files larger than 20mb in the myfiles folder of the current directory'
- askai -post
- get-service | Where-Object { $_.DisplayName -like "*Microsoft*" -and $_.Status -eq "Running" }
- Resolve-Error
- askai 'is there a way to suppress the error?'
- askai -post

## What's next?

- MCP Support
- Already supported in preview6
- https://devblogs.microsoft.com/powershell/preview-6-ai-shell/
