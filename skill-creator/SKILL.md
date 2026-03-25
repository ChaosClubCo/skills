---
name: skill-creator
description: >
  Create new skills, modify and improve existing skills, measure skill performance through evals, and optimize trigger density for reliable activation. This skill should be used when creating a skill from scratch, when editing or refining an existing skill's description or body, when a skill isn't triggering reliably, when running benchmarks to measure skill activation variance, when packaging a skill for distribution, or when optimizing trigger phrases for better coverage. Also triggers on: write a new skill, create a SKILL.md, improve an existing skill, skill not triggering, skill description too vague, add trigger phrases, trigger density low, skill benchmark, skill eval, skill performance test, measure skill accuracy, skill iteration, skill refinement, skill packaging, skill zip, SKILL.md frontmatter, skill body content, skill activation score, skill variance analysis, "my skill doesn't fire", "this skill is too generic", "how do I make this skill better", progressive disclosure in skills, bundled resources, skill lifecycle.
license: MIT
---

# Skill Creator

Full lifecycle support for Claude Code skills: ideation → authoring → evals → packaging.

## Skill Structure

```
skill-name/
├── SKILL.md          # Required: frontmatter + instructions body
├── README.md         # Optional: user-facing documentation
└── resources/        # Optional: templates, examples, reference data
    ├── template.md
    └── examples/
```

## SKILL.md Format

```yaml
---
name: skill-name          # kebab-case, matches directory name
description: >            # Determines when Claude loads this skill
  [Dense trigger description — see below]
license: MIT              # or other SPDX identifier
---

# Skill Title

[Instructions body — loaded when skill activates]
```

## Writing High-Density Descriptions

The description field is everything. Weak descriptions miss activation. Strong descriptions catch edge cases.

**Weak (LOW score):**
```yaml
description: Guide for creating effective skills.
```

**Strong (HIGH score):**
```yaml
description: >
  Create new skills, modify and improve existing skills, measure skill
  performance through evals, and optimize trigger density. This skill
  should be used when creating a skill from scratch, when editing an
  existing skill's description, when a skill isn't triggering reliably,
  or when running benchmarks. Also triggers on: SKILL.md authoring,
  trigger density low, skill not firing, write a new skill, skill eval,
  skill packaging, progressive disclosure, bundled resources.
```

**Rules for density:**
1. Action-oriented first sentence (verb + object)
2. "This skill should be used when..." section with 5+ scenarios
3. "Also triggers on:" list with 12-15 alternative phrasings, error states, tool names
4. Cover synonyms: create/write/build/author, skill/plugin/module

## Running Evals

Test trigger reliability before shipping:

```bash
# Manual eval: give Claude each prompt and check if skill activates
prompts=(
  "write a new skill for X"
  "my skill isn't triggering"
  "improve this skill's description"
  "create a SKILL.md"
  "skill doesn't fire"
)

# Target: >90% activation rate across all prompts
```

Score categories:
- **HIGH**: >90% activation, covers error states and synonyms
- **MEDIUM**: 70-90%, misses some edge case phrasings
- **LOW**: <70%, too generic or missing key trigger phrases

## Packaging

```bash
# From the skill directory
zip -r skill-name.zip skill-name/ --exclude "*.DS_Store" --exclude "*/.mcpb-cache/*"
```

Verify before distribution:
- [ ] `SKILL.md` present with valid frontmatter
- [ ] `name` field matches directory name
- [ ] Description scores HIGH on at least 5 test prompts
- [ ] No secrets or local paths in content
