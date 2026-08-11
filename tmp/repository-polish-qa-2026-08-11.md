# Repository Polish QA Inventory — 2026-08-11

## Requested outcome

- User request: fully polish the public `Sunwood-ai-labs/delegate-to-grok-skill` repository with `repository-polish`.
- Mode: `完全整備`.

## Planned deliverables

| deliverable | planned change | verification |
| --- | --- | --- |
| Public repository metadata | Add concise description, topics, and a Pages homepage URL. | `gh repo view` and `gh api` after update. |
| README.md | Add a coherent hero, icon, badges, documentation links, clearer installation, security, and contributor paths. | Markdown link/path checks, heading review, and rendered-link inspection. |
| README.ja.md | Keep the Japanese README structurally parallel with the English README. | Heading/order parity and path checks. |
| Visual identity | Add one original, flat SVG routing-and-merge icon for README and VitePress favicon/logo. | SVG markup inspection and reference checks. |
| Bilingual docs | Add VitePress home, getting-started, safe-delegation, troubleshooting, and release pages in English and Japanese. | `npm run docs:build`, config/nav/sidebar and page-path checks. |
| CI and Pages | Add docs build validation and deploy GitHub Pages from `main`. | Workflow inspection, Actions runs, and live Pages URL. |
| Release evidence | Keep current QA references valid after docs-path migration. | Release-QA validator and link/path checks. |

## Final claims and evidence required

| planned claim | required evidence |
| --- | --- |
| The repository has a public documentation site. | Successful Pages workflow and an opened live URL. |
| English and Japanese docs are structurally parallel. | Matching nav/sidebar entries and page-path/heading checks. |
| Installation and documentation links use the renamed repository slug. | Repository-wide old-slug search and link checks. |
| The icon is original and consistently wired. | SVG source review plus README and VitePress references. |
| CI validates the skill package and documentation build. | Successful workflow runs on the pushed commit. |
| The public repository metadata is complete. | GitHub API metadata response. |

## Initial state

- Public repository, `main`, and `v0.1.0` release exist.
- English and Japanese READMEs exist; no VitePress config, docs package, Pages workflow, repository description, topics, or homepage exists.
- Existing docs are static Markdown only; Pages API returns `404` because no site is configured.
- Node `v24.15.0` and npm `11.12.1` are available locally.

## Signoff status

- structural QA: pass — README heading parity, renamed-slug search, docs paths, icon references, and workflow targets were checked.
- docs build QA: pass — `npm run docs:build --prefix docs` and `npm run docs:verify --prefix docs` completed successfully.
- SVG QA: pass — `svg-header-layout-lint` reported no issues for `docs/public/icon.svg`.
- Header image QA: superseded — `header-v1.png` was removed during the delegation-first rebrand and replaced by the text-free `docs/public/header-v2.png`, which visual inspection confirmed as a central distribution-and-merge workflow without third-party branding.
- dependency audit: reviewed — `npm audit` reports three known VitePress 1.6.4 development-server dependency advisories with no stable fix available from npm; production Pages deploys static build output and the local dev server remains loopback-only by default.
- Pages deployment QA: pass — `Deploy documentation` run `31458965143` completed successfully after Pages was enabled as workflow-backed; English home, Japanese home, and getting-started page each returned HTTP 200 at `https://sunwood-ai-labs.github.io/delegate-to-grok-skill/`.
- metadata QA: pass — GitHub description, homepage, and eight public topics were set and read back through `gh repo view`.
- staged payload QA: pass — `check_commit_payload.ps1` inspected 25 files totaling 0.123 MiB; no warnings or blocked payloads.
- final Git status QA: pass — public polish commit `16f2cb0` was pushed to `main`; this final evidence update is the only remaining local change before its own commit and push.
