---
name: developing-skills
description: >
  Authoritative guide for authoring, editing, and debugging Claude skills under
  the Agent Skills open standard. Covers SKILL.md, YAML frontmatter, gerund
  naming, pushy descriptions (Claude under-triggers by default), trigger
  density, the 500-line recommendation, progressive disclosure, autonomy
  calibration, gotchas capture, script promotion, cross-surface portability
  (Claude.ai, API, Claude Code, Cowork), Claude Code hooks (UserPromptSubmit,
  PreToolUse, PostToolUse, Stop), and the draft-test-review-improve loop. Use
  whenever the user is writing a new SKILL.md, editing a skill, debugging why a
  skill won't trigger, optimizing a description, planning progressive
  disclosure, configuring hooks, or packaging a skill — even if they don't
  explicitly say "skill". Also triggers on: authoring SKILL.md, skill not
  firing, YAML errors, skill-rules.json, description optimization,
  under-triggering, Agent Skills spec, pushy description, gerund naming, allowed-tools frontmatter, script promotion, all-caps imperatives, explain-the-why pattern.
version: "3.0.1"
---

# Developing Skills — 2026 Authorship Guide

Authoritative guide to skill authorship under the Agent Skills open standard. Covers the iteration loop, frontmatter spec, the four high-leverage authoring patterns (pushy descriptions, explain-the-why, autonomy calibration, gotchas), and when to split into `references/`.

## TL;DR

The single biggest determinant of whether a skill is useful is whether Claude **triggers it at all**. Claude under-triggers by default. Your description field has to be dense, specific, and slightly pushy. Everything else (progressive disclosure, hooks, scripts) is scaffolding around that core fact.

## Quick-Start Decision Tree

```
What are you doing?
  ├─ Writing a new skill ──────── Start at "Core Loop" below
  ├─ Editing an existing skill ── Start at "Core Loop", treat current skill as draft N
  ├─ Skill won't trigger ─────── See references/troubleshooting.md
  ├─ Configuring hooks ────────── See references/hooks.md (Claude Code only)
  └─ Optimizing description ──── See references/trigger-patterns.md + OPTIMIZATION_RUNBOOK.md
```

---

## Usage Examples

**Example 1 — New skill from scratch.**
User: "Build a skill that helps write API documentation."
→ Gerund name: `documenting-apis`. Draft SKILL.md with pushy description. Write 3 test prompts. Run them with and without the skill. Compare. Iterate the description and body based on failures. Only add `references/` if SKILL.md is approaching 500 lines.

**Example 2 — Skill isn't triggering.**
User: "My skill never activates even when I mention the right keywords."
→ Check in order: (1) is the description pushy enough, (2) does it include the user's actual phrasing (not just canonical terms), (3) does YAML parse cleanly, (4) does `name` match the directory, (5) for Claude Code: are hooks registered? See `references/troubleshooting.md` for the full ladder.

**Example 3 — Skill works on your test prompts but fails in the wild.**
User: "It fires on the examples I wrote but misses real user questions."
→ Classic over-fit. The description matches your eval phrasing but not natural user phrasing. Fix: capture 5-10 real user messages (from transcripts) that *should* have triggered the skill, rewrite the description to cover their actual vocabulary, re-run evals.

---

## Core Loop: Draft → Test → Review → Improve

This is the loop. Evals-first is one valid *start* to the loop, not a replacement for the loop.

1. **Draft** — write SKILL.md with pushy description, key content, self-verification checklist.
2. **Test** — run 2-3 realistic prompts against the skill (ideally also against a no-skill baseline for comparison).
3. **Review** — read the transcripts, not just the final outputs. Where did Claude waste time? Where did the skill's instructions confuse it? Where did Claude ignore the skill entirely?
4. **Improve** — rewrite based on what you saw. Remove dead weight. Add missing context. Capture gotchas.
5. **Repeat** until the skill is reliably triggering and producing the output you want.

**Why iterative, not eval-first:** Eval-first authorship tends to over-fit to the 3 prompts you wrote. The real trigger space emerges only when you watch Claude work against your skill. See `references/trigger-patterns.md` for description optimization against a held-out test set.

---

## YAML Frontmatter

```yaml
---
name: gerund-name-here                    # required, must match directory name
description: >                            # required, pushy, third-person, dense
  One-line (or wrapped) description of what the skill does AND when to use it.
  Use whenever the user does X, Y, or Z — even if they don't explicitly say W.
  Also triggers on: keyword1, keyword2, ...
version: "3.0.1"                          # optional but recommended (semver)
allowed-tools: Bash, Read, Write, Edit    # optional — restricts tool access
disable-model-invocation: false           # optional — if true, only /slash invokes
---
```

### Required fields

- `name` — lowercase letters, numbers, hyphens only. **64 character maximum.** Must match the directory name exactly.
- `description` — **1024 character maximum** per the Agent Skills open spec. In Claude Code, `description` + optional `when_to_use` combined truncates at 1536.

### Optional fields

- `version` — semver. Not enforced by Anthropic; useful for your own change tracking.
- `allowed-tools` — restrict which tools this skill can invoke. Minor security win.
- `disable-model-invocation` — set true if you only want this invoked via `/skill-name`, not auto-triggered.

---

## Gerund Naming

The first hyphen-segment ends in `-ing`. It reads as a verb: *"what is this skill doing?"*

**Valid:** `documenting-apis`, `building-dashboards`, `tracking-expenses`, `developing-skills`.
**Invalid:** `api-documenter`, `dashboard-builder`, `expense-tracker`.

Anthropic recommends but does not *enforce* this. Your internal validator may enforce it as FAIL. Either way, the convention makes skill libraries scannable.

---

## The Pushy Description (Pattern #1)

**Claude under-triggers skills.** This is the #1 failure mode. A skill with a perfect body but a weak description will sit unused forever.

**Fix:** write descriptions that are a little pushy. State the activation context explicitly. Use "use whenever" / "even if the user doesn't say X". Include the actual phrases a user might type — including casual, lowercase, abbreviated variants.

### Before / After

**Weak:**
> Helps with dashboards.

**Keyword-dense but not pushy (common mistake):**
> Creates dashboards. Activates when building dashboards, displaying metrics, or visualizing data.

**Pushy (what you want):**
> Creates fast, scannable dashboards for displaying internal metrics. Use this skill whenever the user mentions dashboards, data visualization, internal metrics, KPIs, or wants to display any kind of company data — even if they don't explicitly ask for a "dashboard". Also triggers on: display this data, show me the numbers, quick report, metrics page.

The pushy version wins because Claude can match on what users actually say ("show me the numbers") rather than what you hope they'll say ("build a dashboard").

### Rules of thumb

- 4-8 distinct trigger phrases minimum.
- Include at least one casual/lowercase variant.
- Include a "use whenever X — even if Y" clause.
- Name the adjacent skills this might compete with, if any.
- Test on real user messages from transcripts, not your imagination.

See `references/trigger-patterns.md` for more before/after examples and the description optimization workflow.

---

## The 500-Line Recommendation (Pattern #2)

Anthropic's best practices doc: *"Keep SKILL.md body under 500 lines for optimal performance."* It is a **recommendation**, not a hard spec requirement.

**Why it matters:** every line of SKILL.md is loaded into context when the skill triggers. Long SKILL.md files crowd out conversation history and other skills. Production teams report 40-60% token savings from restructuring monolithic skills into `references/`.

**When to split:**

- **Approaching 500 lines** — split per Anthropic recommendation.
- **Your internal standard is stricter** — split earlier (your old rule was >100 lines, which is aggressive but defensible if token budget is tight).
- **Content is mutually exclusive** — if a user only needs the AWS reference or only the GCP reference, never both, split by domain even if the combined file fits under 500.

See `references/progressive-disclosure.md` for the split heuristics, the `scripts/` vs `assets/` vs `references/` decision, and domain-split patterns.

---

## Explain the Why (Pattern #3)

**Yellow flag:** if you catch yourself writing `ALWAYS`, `NEVER`, or `MUST` in all-caps, stop. Reframe.

Today's models have good theory of mind. State the rule, explain the reason, and trust Claude to generalize to cases you didn't anticipate.

### Before / After

**All-caps imperative:**
> NEVER use field injection. ALWAYS use constructor injection.

**Rule + reasoning:**
> Use constructor injection. Field injection breaks testability because we can't mock the field without loading Spring context — and our test suite runs without Spring.

The second version tells Claude *why*, which lets it apply the principle when a new injection pattern appears that your skill never covered.

**When bare imperatives are still correct:** genuinely fragile, irreversible, or security-critical steps (DB migrations, auth token handling, destructive operations). In those cases, keep it terse. See "Autonomy Calibration" below.

---

## Autonomy Calibration (Pattern #4)

Think of Claude working through your skill as a robot on a path. Two terrains:

- **Narrow bridge with cliffs.** One safe way forward. Specific guardrails, exact steps, low freedom. Example: database migrations, production deploys, payment flows, anything irreversible.
- **Open field, no hazards.** Many paths lead to success. General direction, trust Claude to find the route, high freedom. Example: code reviews, writing documentation, exploring a codebase.

**Calibration rule:** match freedom to blast radius. Lock Claude down where mistakes are expensive; let it improvise where they're cheap.

A single skill often has both terrains — use rigid step-by-step instructions for the dangerous parts and prose-style guidance for the flexible parts. Don't apply one voice uniformly.

---

## The Gotchas Pattern

The most valuable section in a mature skill is usually `## Gotchas`. It's where real failures go, so future Claude doesn't relearn them.

**What to capture:**

- Things Claude tried that didn't work (and why).
- Edge cases that surprised you on first run.
- Tempting-but-wrong approaches Claude defaulted to.
- Environment-specific behavior (Windows vs. macOS paths, Node versions, etc.).

**What not to capture:**

- General best practices Claude already knows.
- Information covered elsewhere in SKILL.md.

**Update cadence:** every time you use the skill and something goes wrong, append to Gotchas before you close the session. The compounding value is real — a 6-month-old skill with a rich Gotchas section is dramatically better than a pristine one.

See `references/gotchas.md` for example Gotchas entries and the "promote to Gotchas vs. fix in main flow" decision.

---

## Script Promotion Heuristic

If you run the same skill against 3 test cases and Claude independently writes the same helper script every time (e.g., `create_docx.py`, `validate_form.py`, `extract_pdf_text.py`), **promote that script to `scripts/`** in the skill directory.

**Why this wins:**

- Scripts execute via bash; script code never enters context.
- Deterministic operations get deterministic results (no LLM variance).
- Every future invocation saves tokens and time.

**When not to promote:**

- The "helper" is actually skill-specific logic that varies per task.
- The script wraps an API call that changes frequently (version drift risk).
- The operation is cheap enough in tokens that script overhead isn't worth it.

Reference scripts from SKILL.md with a one-liner on when to invoke them. For MCP tools used by scripts, **always use fully-qualified tool names** (e.g., `Supabase:execute_sql` not `execute_sql`) to avoid "tool not found" errors when multiple MCP servers are installed.

---

## Cross-Surface Portability

Skills are a **published open standard** as of January 2026. The same SKILL.md works across:

- claude.ai
- Claude API
- Claude Code
- Cowork (same spec, different activation runtime)

**Critical gotcha:** custom skills **do not auto-sync** between surfaces. A skill uploaded to claude.ai is not available via the API. A skill registered in Claude Code is not available on claude.ai. If you distribute, plan for separate upload to each surface.

**Runtime differences to know:**

- **claude.ai / API:** description-match triggers. No hooks. No tool restrictions beyond `allowed-tools`.
- **Claude Code:** description-match + optional hooks (`UserPromptSubmit`, `PreToolUse`, `PostToolUse`, `Stop`). Can block tool execution via exit code 2. Session state in `.claude/hooks/state/`.
- **Cowork:** description-match, lives inside a plugin package.

The *spec* is the same everywhere. The *activation extras* (hooks, exit-code blocking, session tracking) are Claude Code-only. See `references/hooks.md` for the hook spec.

---

## Pre-Flight: Research Before Writing

If the skill wraps an **established methodology, framework, or specification** (SPARC, TDD, Shape Up, OWASP, RFC process, etc.), **search authoritative sources before writing SKILL.md**. Do not paraphrase from memory.

A skill that misrepresents a named methodology produces incorrect coaching and confuses users who know the real thing. Wrong phase names, missing steps, and invented constraints are worse than no skill.

**Source hierarchy:** canonical repo or original author > official docs > peer-reviewed writeups > summary blogs. Read the primary source.

---

## Golden Path: Creating a Skill End-to-End

1. **Research** — if wrapping a named methodology, find the canonical source first.
2. **Name it** — gerund, lowercase, hyphens, ≤64 chars.
3. **Write a pushy description** — ≤1024 chars, third-person, includes real user phrasings.
4. **Draft SKILL.md** — decision tree, 3 usage examples, core content, self-verification checklist, CLAIMS footer.
5. **Test with 2-3 realistic prompts** — watch the transcripts, not just outputs.
6. **Improve** — rewrite based on what failed. Capture Gotchas.
7. **Split into `references/`** — only if SKILL.md approaches 500 lines (or your internal stricter threshold).
8. **Optimize the description** — run `run_loop.py` against a 20-query eval set (see `OPTIMIZATION_RUNBOOK.md`).
9. **Validate** — run your internal validator; confirm 0 FAIL.
10. **Package and distribute** — use `packaging-skills` for `.skill` file creation.

---

## Self-Verification Checklist

Before shipping a skill:

0. ☐ If wrapping an established methodology, authoritative source was read first.
1. ☐ Name is gerund form, lowercase+hyphens+numbers only, ≤64 chars, matches directory.
2. ☐ Description is third-person, pushy, ≤1024 chars, includes real user phrasings.
3. ☐ SKILL.md is under 500 lines (or you've split into `references/`).
4. ☐ 2-3 realistic test prompts have been run; transcripts reviewed, not just outputs.
5. ☐ `references/` split is sensible — one topic per file, table of contents if a reference is >300 lines.
6. ☐ No all-caps MUSTs where rule+reasoning would work (genuine narrow-bridge cases excepted).
7. ☐ Gotchas section exists or is ready to grow; no placeholders in finished deliverables.
8. ☐ Scripts in `scripts/` are referenced from SKILL.md with a one-liner on when to use.
9. ☐ MCP tool names (if any) are fully qualified.
10. ☐ CLAIMS / COUNTEREXAMPLE / CONTRADICTIONS footer present.
11. ☐ Internal validator passes.

---

## CLAIMS
- [SOURCED] Claude under-triggers skills by default; pushy descriptions measurably improve activation (Anthropic skill-creator SKILL.md, March 2026)
- [SOURCED] The 500-line limit is an Anthropic recommendation, not a spec requirement; progressive disclosure yields 40-60% token savings in production (docs.claude.com best-practices + super-claude ADR)
- [SOURCED] Skills are a published open standard as of January 2026; custom skills do not auto-sync between claude.ai / API / Claude Code (resources.anthropic.com Complete Guide; platform.claude.com)
- [SOURCED] All-caps MUST/ALWAYS/NEVER is flagged by Anthropic's own skill-creator as a yellow flag to reframe (github.com/anthropics/skills)
- [GENERATED] Eval-first authorship over-fits to 3 prompts; the iteration loop outperforms because the trigger space emerges only from real transcripts — reasoned from the over-fitting counterexample in v2.0.0 of this skill
- [GENERATED] Cross-surface skill distribution is underrated as a gotcha; most authors assume sync and discover manually — inferred from Anthropic docs noting it as a named limitation

## COUNTEREXAMPLE
- A skill with a perfectly pushy description can still fail to trigger if YAML frontmatter has a syntax error that prevents parsing. Description optimization presumes a parseable skill.
- Explain-the-why is correct for most cases but wrong for genuinely irreversible operations (DB migrations, destructive deletes) where terse imperatives reduce ambiguity.

## CONTRADICTIONS
- ! "Pushy description" vs. "1024 char cap" — pushy framing costs chars; you will hit the cap on genuinely complex skills. Resolution: move fine-grained trigger enumeration to a `when_to_use` field in Claude Code (1536 combined cap) or accept the cap and prioritize the most distinctive triggers.
- ! "Progressive disclosure improves token efficiency" vs. "cross-file references add cognitive overhead" — splitting into too many tiny files fragments the skill. Resolution: split only on real semantic boundaries (domain, workflow phase), not for pure line-count compliance.
