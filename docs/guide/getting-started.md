# Getting started

## Prerequisites

- Windows PowerShell 5.1+ or PowerShell 7+
- Codex with local skills enabled
- A locally installed `grok` command

Confirm the executable and only authenticate when needed:

```powershell
Get-Command grok
grok models
```

If `grok models` explicitly reports that authentication is required, complete one interactive `grok login --oauth` flow and rerun `grok models`. Do not inspect or copy `auth.json`.

## Install the skill

```powershell
git clone https://github.com/Sunwood-ai-labs/delegate-to-grok-skill.git
Copy-Item -Recurse -Force .\delegate-to-grok-skill\skill "$env:USERPROFILE\.codex\skills\delegate-to-grok"
```

Restart or refresh Codex so it discovers the new local skill.

## Start read-only

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
  -WorkingDirectory 'D:\Projects\example' `
  -Prompt 'Inspect the architecture and summarize it without changing files.'
```

The exact working directory is the default allowed root. Use `-AllowedRoot` only when a reviewed parent directory must cover a child target. Use `-AllowWrites` only for an explicit user-authorized implementation task.
