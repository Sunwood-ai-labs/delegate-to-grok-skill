<p align="center">
  <img src="docs/public/icon.svg" width="112" alt="delegate-to-grok shield and route icon">
</p>

<h1 align="center">delegate-to-grok</h1>

<p align="center">A defensive Codex skill for delegating research and explicitly authorized implementation work to Grok Build on Windows.</p>

<p align="center">
  <a href="https://github.com/Sunwood-ai-labs/delegate-to-grok-skill/actions/workflows/ci.yml"><img src="https://github.com/Sunwood-ai-labs/delegate-to-grok-skill/actions/workflows/ci.yml/badge.svg" alt="Validate workflow"></a>
  <a href="https://github.com/Sunwood-ai-labs/delegate-to-grok-skill/releases/tag/v0.1.0"><img src="https://img.shields.io/github/v/release/Sunwood-ai-labs/delegate-to-grok-skill?display_name=tag" alt="Latest release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/Sunwood-ai-labs/delegate-to-grok-skill" alt="MIT license"></a>
</p>

<p align="center"><a href="README.ja.md">日本語</a> · <a href="https://sunwood-ai-labs.github.io/delegate-to-grok-skill/">Documentation</a> · <a href="SECURITY.md">Security</a> · <a href="CONTRIBUTING.md">Contributing</a></p>

## 🛡️ What it protects

- Uses a wrapper for every headless run—no fragile direct `grok -p` fallback.
- Sends prompts through a temporary file, preserving quotes, commas, multiline content, and Japanese text.
- Performs fresh authentication preflight and postflight checks, with isolated temporary authentication state.
- Serializes invocations with a named mutex to prevent OAuth/session races.
- Defaults to read-only Grok permissions, no Grok subagents, no memory, and an exact-directory filesystem boundary.

## 🚀 Install

Prerequisites: Windows PowerShell 5.1+ or PowerShell 7+, Codex, and a locally installed `grok` command. Authenticate separately with `grok login --oauth` when `grok models` explicitly reports that authentication is needed.

```powershell
git clone https://github.com/Sunwood-ai-labs/delegate-to-grok-skill.git
Copy-Item -Recurse -Force .\delegate-to-grok-skill\skill "$env:USERPROFILE\.codex\skills\delegate-to-grok"
```

Restart or refresh Codex so it discovers the skill.

## 🧭 Use

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
  -WorkingDirectory 'D:\Projects\example' `
  -Prompt 'Review this project architecture without changing files.'
```

The working directory itself is the default allowed root. Specify `-AllowedRoot` only when the task deliberately targets a child of a confirmed parent directory. Add `-AllowWrites` only when the user explicitly requested file changes.

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" -Help
```

## 📚 Documentation

Browse the [English and Japanese documentation site](https://sunwood-ai-labs.github.io/delegate-to-grok-skill/) for setup, safe delegation, troubleshooting, and release notes.

## 🧪 Development

Run the repository checks on Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\verify.ps1
npm --prefix .\docs run docs:build
```

The checks parse the wrapper, validate the skill metadata, exercise `-Help`, and verify that an out-of-bound directory is rejected before Grok is invoked. They do not require a Grok account or network access.

## 🔐 Security

Report vulnerabilities privately and keep OAuth state, prompts containing credentials, and account diagnostics out of issue reports. See [SECURITY.md](SECURITY.md).

## 🤝 Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) before proposing changes. The wrapper must remain the only supported headless invocation path.

## 📄 License

MIT. See [LICENSE](LICENSE).
