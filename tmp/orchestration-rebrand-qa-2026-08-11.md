# Orchestration Rebrand QA Inventory — 2026-08-11

## User outcome

- Rebuild the public identity so it explains what the skill does: Codex delegates work to Grok Build for investigation, implementation, comparison, public X research, and parallel-agent orchestration.
- Remove security/defense-first positioning, shield symbolism, and copy that makes guardrails look like the product.
- Use parallel subagents for product, visual, Material Design, and Devil's Advocate discussion; cross-review their producing outputs.

## Planned public-surface changes

| surface | planned change | verification |
| --- | --- | --- |
| Repository metadata | Replace the defensive description and add orchestration/parallel-delegation topics. | `gh repo view` readback. |
| README.md / README.ja.md | Make delegation, parallel work, and Grok task modes the hero; move safeguards to a concise operating-principles section. | Heading/link/locale-parity check. |
| Docs home and navigation | Reframe home, feature cards, guide labels, and calls to action around orchestration. | VitePress build, docs structure test, source-path review. |
| Icon and header image | Replace shield-first assets with original non-brand orchestration imagery; use them consistently across README and VitePress. | Asset inspection, reference test, payload review. |
| Guides | Preserve the wrapper safeguards as operational detail without calling them the product identity. | English/Japanese heading parity and source review. |

## Final claims requiring evidence

| claim | required evidence |
| --- | --- |
| The public surface describes Codex-to-Grok delegation and parallel work first. | Repository-wide wording search plus README/docs review. |
| The identity no longer uses shield or defense as its primary visual/metaphor. | Asset and alt-text inspection. |
| English and Japanese pages remain structurally parallel. | Docs verification plus matching nav/page paths. |
| Public site and CI remain live after the rebrand. | Successful Actions runs and HTTP 200 checks. |

## Legion roster and required gates

| seat | owner | scope | status |
| --- | --- | --- | --- |
| producer 1 | アイ・カイロ / 委譲の言霊設計官 | bilingual positioning and IA | accepted; peer re-review pass |
| producer 2 | ミラ・フェイズ / 多重路の景観錬成士 | visual identity and asset-use brief | accepted; peer re-review pass |
| material design | カグラ・ノアール / 導線を裁く結界建築士 | user-facing Material Design audit | pass |
| devil's advocate | ノクス・ヴァレン / 反証を裁く冥府の審判 | claim, brand, and rollout-risk audit | resolved after public-state verification |
| second pass | producer 1 ↔ producer 2 | mutual peer review of proposals | pass |

## Final signoff status

- manager_acceptance: accepted — public wording, visual system, and execution-contract positioning were rebuilt with the producer recommendations.
- second_pass_status: pass — both cross-review lanes passed after the wording was corrected to avoid claiming Grok-internal parallelism.
- material_design_status: pass — hierarchy, navigation labels, alt text, and the new workflow imagery passed the final design audit.
- disposition: resolved — commit `9a5e6a1` was pushed to `main`; Validate run `31460624639` and Deploy documentation run `31460624678` succeeded; English and Japanese Pages homes returned HTTP 200 with `header-v2.png` and the delegation-first hero text.
