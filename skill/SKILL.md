---
name: delegate-to-grok
description: Delegate coding, repository inspection, comparisons, web research, and public X search from Codex to the locally installed Grok Build CLI on Windows. Use when a user asks to run or consult Grok, resume Grok Build authentication, compare Codex and Grok, inspect or modify a project with Grok, or perform public X research.
---

# Delegate to Grok Build

Use local **grok** as a secondary coding and research agent. Codex owns scope, safety, verification, and the final report.

## Invocation contract

1. Invoke every headless task through `scripts/invoke-grok.ps1`. Never bypass it with `grok -p`, including on retry.
2. Name `-WorkingDirectory`. The default approved root is exactly that directory; use `-AllowedRoot` only for an explicitly confirmed parent root.
3. The wrapper runs a fresh `grok models` preflight before the task and after it. It fails closed unless both explicitly show a logged-in session and a model list.
4. The wrapper is single-flight: wait up to 30 seconds; treat `GROK_BUSY` as ownership by an existing run. Never start a second Grok or OAuth process.
5. Read-only is the default: `--permission-mode default`, `--sandbox read-only`, `--no-subagents`, and `--no-memory`. `-AllowWrites`, `-AllowSubagents`, and `-AllowMemory` each require a specific user request.
6. Do not use `--always-approve`, `bypassPermissions`, `dontAsk`, persistent debug logs, or a command that exposes prompts or auth files. Prompts always use a temporary `--prompt-file`.
7. Never read or expose `%USERPROFILE%\.grok\auth.json`. The wrapper copies it only to an isolated temporary home and commits it back only after the run and postflight succeed.
8. Put all task text in one `-Prompt` value. This safely supports punctuation, quotes, commas, multiline text, and Japanese.

## Authentication and OAuth recovery

Run `grok models` in a fresh process. A valid result must explicitly say the user is logged in and list available models. Do not infer authentication merely from an existing `auth.json`.

If it explicitly says authentication is missing or expired:

1. Ensure no wrapper invocation or OAuth process is active. If `GROK_BUSY`, wait instead of starting another login.
2. Start exactly one `grok login --oauth`; the wrapper never logs in or out.
3. Read the browser-control skill before browser control. Choose the newest authorization tab created by this flow whose URL carries the active `redirect_uri=http://127.0.0.1:<port>/callback`.
4. Inspect the visible page before clicking **Allow**. Hand password, one-time-code, CAPTCHA, and other secret steps to the user.
5. Verify with a fresh `grok models`. Browser success alone is insufficient.

## Examples

Read-only review:

    & "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
      -WorkingDirectory 'D:\Projects\example' `
      -Prompt 'Inspect the README and main configuration, then summarize the architecture.'

Write task, only after the user requested a change:

    & "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
      -WorkingDirectory 'D:\Projects\example' `
      -Prompt 'Implement the requested fix and run the focused tests.' `
      -AllowWrites

Nested target under a confirmed parent root:

    & "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
      -WorkingDirectory 'E:\ApprovedProject\app' `
      -AllowedRoot 'E:\ApprovedProject' `
      -Prompt 'Review the current test failures without changing files.'

Use `-Help` for the safe invocation summary. `-OutputFormat text` remains a compatibility alias for `plain`; prefer `plain`, `json`, or `streaming-json`.

## Verification and failure handling

- Before a write task, inspect repository instructions and `git status --short`; after it, inspect the diff and independently run proportionate tests. Never commit or push without an explicit user request.
- For research, keep Grok output as evidence and independently verify unstable, security-sensitive, financial, medical, legal, or public-X claims with primary sources.
- `GROK_NOT_FOUND`: report it; do not install or change PATH unless setup was requested.
- `GROK_CWD_INVALID` / `GROK_CWD_DENIED`: correct the exact target or pass only the confirmed root.
- `GROK_BUSY`: wait for or inspect the existing run; never duplicate it.
- `GROK_AUTH_MISSING` / `GROK_AUTH_NEEDED`: use the single-flight OAuth flow, verify `grok models`, then make one wrapper call.
- `GROK_AUTH_UNKNOWN`, `GROK_INVOKE_FAILED`, or `GROK_AUTH_LOST`: stop and report the result; do not retry automatically or modify canonical authentication.
- A PowerShell parameter error means use `-Help`, keep `-Prompt` as one string, and do not fall back to direct CLI syntax.

## X access boundary

Grok Build X Search is for public search and analysis only. It does not authorize posting, replying, liking, reposting, following, DMs, or private-account access. Use a separately authorized workflow for X write operations.

## Usage

Grok.com OAuth sessions consume the account's shared usage allowance. When usage matters, ask the user to check `/usage` in the TUI; do not infer an absolute quota or plan from a percentage alone.
