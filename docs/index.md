---
layout: home

hero:
  name: delegate-to-grok
  text: Defensive Grok Build delegation for Codex
  tagline: A Windows skill that routes every headless Grok task through a guarded, read-only-first PowerShell wrapper.
  image:
    src: /icon.svg
    alt: delegate-to-grok shield and route icon
  actions:
    - theme: brand
      text: Get started
      link: /guide/getting-started
    - theme: alt
      text: View on GitHub
      link: https://github.com/Sunwood-ai-labs/delegate-to-grok-skill

features:
  - title: Prompt-safe transport
    details: Uses a temporary prompt file instead of command-line prompt arguments, preserving quotes, punctuation, multiline text, and Japanese.
  - title: Read-only by default
    details: Starts with a read-only sandbox, default permissions, no Grok subagents, no memory, and an exact-directory boundary.
  - title: Authentication without races
    details: Verifies the Grok session before and after a task, isolates mutable auth state, and serializes wrapper invocations.
---

![A blue protective shield connecting two delegated agent nodes](/header-v1.png)

## Safety first

Codex remains responsible for scope, review, testing, and final conclusions. Grok is a consulted agent—not an autonomous owner of the workspace.

Follow the [getting-started guide](/guide/getting-started) for installation, then read [safe delegation](/guide/safe-delegation) before authorizing a write task.
