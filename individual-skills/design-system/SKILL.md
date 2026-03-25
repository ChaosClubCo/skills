---
name: design-system
description: >
  Design brief generation and anti-slop enforcement for Kyle's cross-lane UI
  work. Produces briefs, generator prompts, and output audits for INT tooling,
  Product builds (FlashFusion, Kinsley Apps), and Sales/SPIKE. Enforces locked
  design tokens (void surface, electric violet, Space Grotesk + Inter), the
  brief-before-generation rule, and 7 anti-slop gates. Triggers on: design
  brief, v0, AI Studio, generator prompt, UI, component, dashboard, panel,
  extension, brief, audit, slop, tokens, Kinsley, FlashFusion, INT tool,
  visual direction, color system, typography, anti-slop.
allowed-tools: "Read, Write, Bash"
---

<objective>
You are operating in Kyle's /Design/ folder. Your job is to produce
design briefs and generator prompts that clear the anti-slop bar —
output that has a real point of view and could not be produced by
pasting "build me a dashboard" into any AI tool.

Brief before generation. Always. No exceptions.
</objective>

<essential_principles>

## Design System — Locked Tokens

Non-Kinsley projects use this system. Do not drift from it.

```
Surface:   #0a0a0f base / #111118 raised / #18181f overlay
Border:    #2a2a38 structural / #1e1e28 secondary
Accent:    hsl(262 83% 68%) — electric violet
           Rule: max 10% visible surface, signal only, never decorative
Text:      #f0f0f5 primary / #9898a8 secondary / #52525e tertiary
Heading:   Space Grotesk 700
Body:      Inter 400/500
Code:      IBM Plex Mono
Scale:     11 / 13 / 14 / 16 / 20px (tight — panel context)
Nav:       Flat. Command palette (⌘K) primary. Max 4 icon tabs.
```

Kinsley Apps: warm cream surface, Nunito, paper material, warm accent.
Never bleed violet into Kinsley. Never bleed Kinsley warmth into INT/Product.

## Anti-Slop Gates — Run Before Every Output

```
[ ] No "clean and modern" language anywhere
[ ] Accent defined as HSL value — not a color name
[ ] One named decision that separates this from category default
[ ] Navigation model chosen and justified
[ ] No sidebar without written one-sentence justification
[ ] Every state defined — nothing blank, nothing waiting
[ ] Generator prompt would not pass "build me a dashboard" test
```

If any gate fails — fix the brief, then generate. Never generate through a failed gate.

## Project Lane Separation

Always confirm lane before starting a brief:
- **INT** — ops/security tooling, dark, dense, metal/void
- **Product** — FlashFusion successor, Kinsley Apps (Fridays only)
- **Sales/SPIKE** — B2B proposals, not UI work

</essential_principles>

<intake>
What do you need?

1. **New brief** — start a brief for a new project
2. **Check brief** — audit an existing brief in /Briefs/
3. **Audit output** — review files in /Generated/ against a brief
4. **Generator prompt** — extract and verify the v0/AI Studio prompt from a brief
5. **Update tokens** — modify the locked design system above
6. **Stitch pipeline** — brief → Stitch → DESIGN.md → React components → deploy
7. **Token drift** — check all briefs against locked tokens (also runs on schedule)
</intake>

<routing>
| Response | Workflow |
|---|---|
| 1 / "new brief" / "brief for [x]" — simple (panel/tool/component) | workflows/new-brief.md |
| 1 / "new brief" — complex (full app / new product / Kinsley app) | elite-ui-design skill Phase 0–2 → then workflows/new-brief.md |
| 2 / "check" / "audit brief" / "review brief" | workflows/check-brief.md |
| 3 / "audit output" / "review generated" | workflows/audit-output.md |
| 4 / "generator prompt" / "v0 prompt" / "prep prompt" | workflows/generator-prompt.md |
| 5 / "update tokens" / "change design system" | workflows/update-tokens.md |
| 6 / "stitch" / "stitch pipeline" / "design to code" | workflows/stitch-pipeline.md |
| 7 / "token drift" / "check drift" / "drift report" | workflows/token-drift-check.md |

**Scope gate for new briefs:**
- Panel / tool / component / extension / internal → direct to new-brief.md
- Full app / new product / Kinsley app / customer-facing → elite-ui-design Phase 0–2 first

If intent is clear without selection — route directly. Do not ask.
</routing>

<error_handling>
**No brief exists for requested project**
→ Do not generate UI
→ Say: "No brief for [project]. Start one? (I'll use the template)"
→ Wait for confirmation before proceeding

**Output in /Generated/ has no matching brief**
→ "Found output with no matching brief. Which project is this for?"
→ Offer to reverse-engineer a brief from the output as a starting point

**Design token conflict between briefs**
→ Flag explicitly — do not silently resolve
→ This SKILL.md is source of truth
→ Propose fix, wait for approval before writing
</error_handling>

<success_criteria>
A brief is complete when:
- All 7 anti-slop gates pass
- Generator prompt is assembled and paste-ready
- Brief is written to /Briefs/[project]-brief-v[N].md
- Correct token set applied (Kinsley vs non-Kinsley)
</success_criteria>