---
layout: home

hero:
  name: delegate-to-grok
  text: Codex-to-Grok delegation for real work
  tagline: Route research, review, comparison, and implementation support to Grok Build while Codex owns scope, validation, and final decisions.
  image:
    src: /icon.svg
    alt: delegate-to-grok orchestration lanes icon
  actions:
    - theme: brand
      text: Get started
      link: /guide/getting-started
    - theme: alt
      text: View on GitHub
      link: https://github.com/Sunwood-ai-labs/delegate-to-grok-skill

features:
  - title: Focused task delegation
    details: Give Grok a bounded investigation, review, comparison, public X research, or implementation-support task from a named workspace.
  - title: Findings back to Codex
    details: Grok supplies evidence and implementation support; Codex remains responsible for scope, validation, and the final decision.
  - title: Explicit execution contract
    details: Permissions, workspace boundaries, authentication checks, and the single-flight run model are made explicit instead of being left to implicit CLI behavior.
---

![Central orchestrator splitting delegation task streams from Codex and merging Grok findings](/header-v2.png)

## Delegation model

Use Grok as a dedicated delegation lane: send a well-scoped task, bring back evidence or a proposed change, then let Codex review and integrate the result. This wrapper is single-flight by design; when you coordinate multiple tracks, do it at the Codex workflow level rather than claiming Grok-internal parallelism.

Follow the [getting-started guide](/guide/getting-started), then read the [delegation contract](/guide/safe-delegation) before authorizing a write task.
