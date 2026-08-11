# delegate-to-grok

A defensive Codex skill for delegating read-only research, repository inspection, and explicitly authorized implementation work to the local Grok Build CLI on Windows.

[日本語](README.ja.md) · [Security](SECURITY.md) · [Safe delegation guide](docs/guides/safe-delegation.md) · [v0.1.0 release notes](docs/releases/v0.1.0.md)

## What it protects

- Uses a wrapper for every headless run—no fragile direct `grok -p` fallback.
- Sends prompts through a temporary file, preserving quotes, commas, multiline content, and Japanese text.
- Performs fresh authentication preflight and postflight checks, with isolated temporary authentication state.
- Serializes invocations with a named mutex to prevent OAuth/session races.
- Defaults to read-only Grok permissions, no Grok subagents, no memory, and an exact-directory filesystem boundary.

## Install

Prerequisites: Windows PowerShell 5.1+ or PowerShell 7+, Codex, and a locally installed `grok` command. Authenticate separately with `grok login --oauth` when `grok models` explicitly reports that authentication is needed.

```powershell
git clone https://github.com/Sunwood-ai-labs/delegate-to-grok-skill.git
Copy-Item -Recurse -Force .\delegate-to-grok-skill\skill "$env:USERPROFILE\.codex\skills\delegate-to-grok"
```

Restart or refresh Codex so it discovers the skill.

## Use

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
  -WorkingDirectory 'D:\Projects\example' `
  -Prompt 'Review this project architecture without changing files.'
```

The working directory itself is the default allowed root. Specify `-AllowedRoot` only when the task deliberately targets a child of a confirmed parent directory. Add `-AllowWrites` only when the user explicitly requested file changes.

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" -Help
```

## Development

Run the repository checks on Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\verify.ps1
```

The checks parse the wrapper, validate the skill metadata, exercise `-Help`, and verify that an out-of-bound directory is rejected before Grok is invoked. They do not require a Grok account or network access.

## License

MIT. See [LICENSE](LICENSE).
