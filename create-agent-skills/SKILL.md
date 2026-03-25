---
name: create-agent-skills
description: Expert guidance for creating, writing, building, testing, and refining Claude Code Skills — modular SKILL.md packages with optional bundled resources (scripts, references, assets) that give Claude specialized domain knowledge and reliable workflows. This skill should be used when the user asks to create a skill, write a new SKILL.md, author a skill from scratch, improve an existing skill, understand skill structure, add bundled resources to a skill, write skill descriptions and trigger phrases, debug why a skill isn't activating, optimize a skill's description for triggering accuracy, understand the YAML frontmatter fields, build a reusable skill package, add scripts/ or references/ directories, understand progressive disclosure in skills, or package a skill for distribution. Also triggers on: SKILL.md not working, skill not triggering, write a SKILL.md, how do I build a skill, create a skill for my team, skill authoring guide, how do skills work, skill description best practices, skill trigger phrases, skill frontmatter, bundled skill resources, how do I make a skill fire reliably, skill packaging, skill zip, improve my skill description, skill not activating, why isn't my skill firing, skill trigger density, write skill instructions, skill body content, skill references directory, skill scripts directory, skill assets directory.
license: Complete terms in LICENSE.txt
---

# Create Agent Skills

This skill provides expert guidance for creating, writing, and refining Claude Code Skills — the primary mechanism for extending Claude with specialized domain knowledge, reusable workflows, and bundled resources.

## What Is a Skill?

A skill is a directory containing a required `SKILL.md` file and optional bundled resources. When Claude detects that a user's request matches the skill's description, it loads the SKILL.md body into context and uses it to guide the response.

## Directory Structure

```
skill-name/
├── SKILL.md                 ← Required. Contains metadata + instructions.
├── scripts/                 ← Optional. Executable code run without loading into context.
│   └── process.py
├── references/              ← Optional. Documentation loaded into context as needed.
│   └── schema.md
└── assets/                  ← Optional. Template files used in output (not loaded into context).
    └── template.docx
```

## SKILL.md Structure

```yaml
---
name: skill-name                    # kebab-case, matches directory name
description: |                      # THE most important field — determines when Claude activates
  [Action-oriented description + dense trigger phrases covering all the ways a user would ask]
license: Complete terms in LICENSE.txt
---

# Skill Title

[Body: instructions, workflows, references, examples — written for another Claude instance to consume]
```

## Writing the Description (Trigger Density)

The `description` field is read at every turn to decide whether to load the skill. It must be:

1. **Action-oriented**: Start with what the skill does, not what it is
2. **Trigger-dense**: Include 10–20+ varied phrases covering how users would ask for this
3. **Specific**: Avoid generic phrases like "helps with X" — use concrete task names
4. **Intent-covering**: Cover direct requests, indirect mentions, error states, and tool names

**Weak (LOW score):**
```yaml
description: Helps with code reviews. Use when reviewing code.
```

**Strong (HIGH score):**
```yaml
description: Performs structured code reviews covering security, performance, and correctness.
Use when the user asks to review a PR, audit code quality, check for vulnerabilities, assess
test coverage, or evaluate code before merging. Also triggers on: review my code, look at this
diff, check my PR, find bugs in this, security audit, is this production ready, code health check,
OWASP review, check for hardcoded secrets, review before shipping.
```

## Progressive Disclosure

Skills use a three-tier loading model to manage context efficiently:

1. **Metadata (name + description)** — Always in context (~100 words). Used for activation decisions.
2. **SKILL.md body** — Loaded when skill activates (<5k words recommended)
3. **Bundled resources** — Loaded only when Claude determines they're needed (unlimited size)

Keep SKILL.md body lean. Move detailed reference material, schemas, and examples to `references/` files.

## Bundled Resources

### scripts/
- Executable code for deterministic, repeatable operations
- Run without loading into context window (token efficient)
- Example: `scripts/rotate_pdf.py`, `scripts/init_project.sh`

### references/
- Documentation Claude loads when it determines it's needed
- Keep SKILL.md body lean; reference files handle detail
- Example: `references/api_schema.md`, `references/company_policies.md`

### assets/
- Template files, images, fonts used in skill output
- Never loaded into context — copied/used directly
- Example: `assets/report_template.docx`, `assets/logo.png`

## Packaging for Distribution

```bash
# Package a skill into a distributable zip
scripts/package_skill.py path/to/skill-name/

# The script validates first (YAML, naming, description quality), then creates skill-name.zip
```

## Best Practices

1. Name the skill with a gerund verb: `debugging-code`, `creating-reports`, `managing-tickets`
2. Write the description as if you're telling another Claude "here's when to use this"
3. Include error-state triggers ("X not working", "X isn't firing") — these are high-value
4. Keep SKILL.md under 5,000 words; move large content to references/
5. Test trigger reliability by asking in varied phrasings and checking if the skill activates
