# Delegation contract

The wrapper makes delegation predictable by defining how prompts, permissions, workspace scope, authentication, and one-at-a-time Grok CLI runs behave.

## Define the task boundary

Use `scripts/invoke-grok.ps1` for every headless task. Do not fall back to `grok -p`, even for a quick retry. Put one complete task string in `-Prompt`; the wrapper writes it to a temporary UTF-8 file before invoking Grok.

Read-only is the default. The wrapper supplies a read-only sandbox, default permissions, no Grok subagents, no memory, and an exact-directory boundary. A write task needs an explicit user request and `-AllowWrites`.

## Keep the session coherent

The wrapper checks `grok models` before and after the task. It accepts only a result that explicitly confirms login and lists models. A named mutex prevents a second wrapper process from racing authentication state.

When authentication is explicitly absent, run exactly one interactive `grok login --oauth` flow, then verify it with `grok models`. Do not read, repair, or expose the canonical authentication file.

## Return findings to Codex

Before a user-authorized write task, record repository instructions and `git status --short`. Afterward, inspect the complete diff and independently run proportionate tests. The wrapper never commits, pushes, logs in, logs out, or bypasses permission prompts.

For public X research, collect direct URLs but do not post or interact. Treat Grok output as evidence and independently verify time-sensitive or high-stakes claims with primary sources.
