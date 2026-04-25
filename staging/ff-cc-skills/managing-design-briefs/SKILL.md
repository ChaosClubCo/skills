---
name: managing-design-briefs
description: >
  Generates design briefs, enforces anti-slop gates, and manages locked design
  tokens for cross-lane UI work with switchable brand profiles. Ships with INT
  profile (enterprise-clean, void surface, electric violet, Space Grotesk +
  Inter) and FlashFusion profile (neon-glass, dark-mode, purple glow, Poppins
  + Inter). Enforces the brief-before-generation rule and 7 anti-slop gates
  across all profiles. Activates when user mentions design brief, v0, AI
  Studio, generator prompt, UI, component, dashboard, panel, extension, brief,
  audit, slop, tokens, FlashFusion, INT tool, visual direction, color system,
  typography, anti-slop, Stitch pipeline, token drift, or any request to build
  or review a UI. Also triggers on: brief before generation, FlashFusion UI,
  design tokens, locked tokens, anti-slop check, or does this pass the slop
  gates.
allowed-tools: Bash, Read, Write
version: "3.0.0"
---

# Managing Design Briefs

Brief-before-generation system with locked design tokens and anti-slop enforcement. Two brand profiles (INT, FlashFusion) share the same workflow — only tokens and aesthetic direction differ.

## Core Rule

**Brief before generation. Always. No exceptions.**

If no brief exists for the requested project — stop, offer to create one, wait for confirmation.

## Quick-Start Decision Tree

```
Request arrives
  ├─ New UI / component / dashboard ──────── Which profile? → Create brief → references/new-brief.md
  ├─ Audit existing brief ────────────────── references/check-brief.md
  ├─ Audit generated output (v0/Stitch) ──── references/audit-output.md
  ├─ Extract generator prompt ────────────── references/generator-prompt.md
  ├─ Update locked tokens ────────────────── references/update-tokens.md
  ├─ Brief to code via Stitch ────────────── references/stitch-pipeline.md
  ├─ Check for token drift ───────────────── references/token-drift-check.md
  └─ Sales/SPIKE deliverable ─────────────── Not UI work → redirect to doc/pptx/ROI skill
```

---

## Usage Examples

**Example 1 — New INT dashboard brief**
User: "Create a design brief for a security monitoring dashboard."
→ Confirm profile: INT. Walk through template sections 1–8. Apply INT tokens (void surface, electric violet, Space Grotesk). Run all 7 anti-slop gates. Save as `Briefs/security-monitor-brief-v1.md`.

**Example 2 — FlashFusion landing page audit**
User: "Audit the v0 output for the FlashFusion landing page."
→ Load FlashFusion brief. Check token compliance: bg0 #0F0618, primaryGlow #A855F7, Poppins headings. Run anti-slop gates. Check glassmorphic card rendering. Verdict: SHIP / FIX / REGENERATE.

**Example 3 — Token drift scan**
User: "Check if any briefs have drifted from locked tokens."
→ Load both profiles' locked tokens. Grep all briefs for deviations. Grep generated code for Tailwind approximations (e.g., `bg-gray-900` instead of exact hex). Classify drift severity. Report.

---

## Brand Profile: INT

Enterprise-clean, accessibility-forward, dark dense aesthetic.

```
Surface:   #0a0a0f base / #111118 raised / #18181f overlay
Border:    #2a2a38 structural / #1e1e28 secondary
Accent:    hsl(262 83% 68%) — electric violet
           Max 10% visible surface. Signal only, never decorative.
Text:      #f0f0f5 primary / #9898a8 secondary / #52525e tertiary
Heading:   Space Grotesk 700
Body:      Inter 400/500
Code:      IBM Plex Mono
Scale:     11 / 13 / 14 / 16 / 20px
Nav:       Flat. Command palette primary. Max 4 icon tabs.
```

**INT project lanes:** Ops/security tooling, internal tools, admin dashboards.

---

## Brand Profile: FlashFusion

Neon-glass, dark-mode primary, glassmorphic card aesthetic.

```
Surface:   bg0 #0F0618 / bg1 #1A0B2E / bg2 #251443
Border:    border0 rgba(168, 85, 247, 0.2) / border1 rgba(168, 85, 247, 0.4)
Accent:    primaryGlow #A855F7 / secondaryGlow #F472B6 / cyanAccent #22D3EE
Gradient:  accentGradient linear-gradient(90deg, #A855F7 0%, #F472B6 55%, #22D3EE 100%)
Text:      #F8FAFC primary / #CBD5E1 secondary / #64748B tertiary
Heading:   Poppins 600/700
Body:      Inter 400/500
Code:      JetBrains Mono
Scale:     12 / 14 / 16 / 20 / 24 / 32px
Nav:       Bottom nav for mobile. Top nav for desktop. Glassmorphic cards for content.
Glass:     background: rgba(15, 6, 24, 0.6); backdrop-filter: blur(12px);
           border: 1px solid rgba(168, 85, 247, 0.2); border-radius: 16px;
```

**FlashFusion project lanes:** Marketing site, product UI, creator tools, Substack embeds.

---

## Cross-Profile Isolation (Mandatory)

- Never bleed violet (#A855F7) into INT at FlashFusion saturation. INT uses hsl(262 83% 68%).
- Never use FlashFusion glass effects in INT. INT is flat and dense.
- Never use Space Grotesk in FlashFusion. Never use Poppins in INT.
- Never use INT's void surface (#0a0a0f) in FlashFusion. FlashFusion uses #0F0618.
- If both profiles are active in the same session, confirm profile before every output.

---

## Anti-Slop Gates (Both Profiles)

Run before every output. All 7 must pass before generating.

1. No "clean and modern" language anywhere
2. Accent defined as HSL/hex value — not a color name
3. One named decision separating this from the category default
4. Navigation model chosen and justified
5. No sidebar without a written one-sentence justification
6. Every state defined — nothing blank, nothing waiting
7. Generator prompt would not pass "build me a dashboard" test

These gates apply identically to INT and FlashFusion. A brief that fails any gate is not ready for generation.

---

## Task Router

Read the relevant reference file for the task. Do not load all files.

| Task | Reference | Summary |
|------|-----------|---------|
| New brief | new-brief.md | Confirm profile → scope gate → template sections 1–8 → anti-slop → save |
| Audit brief | check-brief.md | Completeness → anti-slop re-run → token consistency → generator readiness |
| Audit output | audit-output.md | Load brief → token compliance → anti-slop visual → state coverage → verdict |
| Generator prompt | generator-prompt.md | Verify brief → assemble sections → adapt for target (v0/AI Studio/Claude) |
| Update tokens | update-tokens.md | Identify change → scope impact → update skill → version briefs → bleed check |
| Stitch pipeline | stitch-pipeline.md | Verify brief → extract prompt → prepare DESIGN.md → generate → audit → max 3 regen |
| Token drift check | token-drift-check.md | Load tokens → check briefs → grep generated code → classify severity → fix |

---

## Scope Gate for New Briefs

- Panel / tool / component / extension → Create brief directly
- Full app / new product → Run elite-ui-design skill Phase 0–2 first, then create brief

---

## Folder Structure

```
SKILL.md                              ← you are here
Briefs/
  design-brief-template.md            ← fill-in template
  [project]-brief-v[N].md             ← versioned briefs, never overwrite
references/
  new-brief.md                        ← create a new brief
  check-brief.md                      ← audit an existing brief
  audit-output.md                     ← audit v0/Stitch/Artifacts output
  generator-prompt.md                 ← extract copy-paste prompt
  update-tokens.md                    ← controlled token changes
  stitch-pipeline.md                  ← brief → code via Stitch
  token-drift-check.md               ← scan for token drift
Generated/                            ← v0 / AI Studio outputs for audit
Archive/                              ← outdated versions
```

---

## Edge Cases

**Mixed-profile session:** If the user asks for both INT and FlashFusion work in one session, treat each request independently. Confirm profile before each output. Never carry token state from one profile to the next.

**Token update cascades:** Changing a locked token affects all briefs using that profile. The update-tokens workflow handles: change identification, impact scoping, brief versioning, stale generator prompt flagging, and cross-profile bleed checking.

**v0 approximations:** v0 often substitutes Tailwind utility classes for exact tokens (e.g., `bg-gray-900` instead of `#0a0a0f`). The audit workflow catches these and reports exact deviations.

---

## Self-Verification Checklist

Before delivering any design brief or audit:
1. Profile is declared (INT or FlashFusion)
2. All 7 anti-slop gates passed
3. Tokens match the locked profile exactly (no approximations)
4. Cross-profile isolation verified (no bleed)
5. All states defined (empty, loading, error, success, edge)
6. Navigation model chosen and justified
7. Brief saved with version number (never overwrite)

---

## CLAIMS
- The brief-before-generation rule prevents 80%+ of "generic AI output" by forcing design decisions before code generation
- Anti-slop gates catch the most common failure modes: vague aesthetic language, undefined states, unjustified navigation, and category-default outputs

## COUNTEREXAMPLE
- A brief can pass all 7 anti-slop gates and still produce mediocre output if the design decisions themselves are uninspired — the gates ensure specificity, not creativity

## CONTRADICTIONS
- "Locked tokens" vs. design evolution — tokens must change sometimes, which is why the update-tokens workflow exists with cascade tracking
- "Never bleed between profiles" but both use Inter for body text — this is intentional (Inter is neutral), but could be seen as token overlap
