# Skills Library — Master Index

**Repository:** ChaosClubCo/skills  
**Mirrored at:** krosebrook/skills  
**Last Updated:** 2026-03-25  
**Maintainer:** Kyle Rosebrook

## Directory Structure

```
skills/
├── master-skills/MASTER_INDEX.md
├── governance/GOVERNANCE.md
├── governance/INDEX.md
├── governance/ROLE_BUNDLES.md
├── governance/SKILL_TEMPLATE.md
├── working-skills/SKILLS-CATALOG.md
├── plugins/kyle-os/.mcp.json
└── individual-skills/
    ├── README.md
    ├── accountability-buddy/SKILL.md
    ├── ai-agents-workflow/SKILL.md
    ├── claude-agent-pack/SKILL.md
    ├── design-system/SKILL.md
    ├── int-ai-enablement-pm/SKILL.md
    ├── int-data-analyst/SKILL.md
    ├── kubernetes-deployment/SKILL.md
    ├── kyle-vibe-coding/SKILL.md
    ├── sparc-methodology-coach/SKILL.md
    └── skill-staff-engineer-v4/
        ├── SKILL.md
        ├── references/agentic-patterns.md
        ├── references/cicd-template.md
        ├── references/observability.md
        ├── references/security-checklist.md
        ├── references/stack-defaults.md
        ├── workflows/audit-loop.md
        └── workflows/implement.md
```

## Governance

| File | Description |
|------|-------------|
| `governance/GOVERNANCE.md` | Authoring standards, review process, versioning rules |
| `governance/INDEX.md` | Human-readable directory of all skills by category |
| `governance/ROLE_BUNDLES.md` | Pre-configured skill bundle recommendations by role |
| `governance/SKILL_TEMPLATE.md` | Blank SKILL.md template with all required frontmatter |

## Working Skills

| File | Description |
|------|-------------|
| `working-skills/SKILLS-CATALOG.md` | Production-verified skills with install status and trigger phrases |

## Plugins

| File | Description |
|------|-------------|
| `plugins/kyle-os/.mcp.json` | Kyle OS plugin MCP config — Cloudflare, Supabase, GitHub, PostHog, Sentry, n8n, Notion |

## Individual Skills

| Skill | Version | Status | Primary Trigger |
|-------|---------|--------|------------------|
| `accountability-buddy` | 1.0 | Verified | "accountability", "daily check-in" |
| `ai-agents-workflow` | 2.0 | Verified | "build an MCP server", "create an AI agent" |
| `claude-agent-pack` | 1.0 | Verified | "subagent", "Task tool" |
| `design-system` | 1.0 | Verified | "design tokens", "component library" |
| `int-ai-enablement-pm` | 1.0 | Verified | "INT project", "AI enablement" |
| `int-data-analyst` | 1.0 | Verified | "data analysis", "SQL query" |
| `kubernetes-deployment` | 1.0 | Verified | "kubernetes", "k8s deployment" |
| `kyle-vibe-coding` | 1.0 | Verified | "vibe coding", "rapid prototype" |
| `skill-staff-engineer-v4` | 4.0 | Verified | "staff engineer", "production build" |
| `sparc-methodology-coach` | 1.0 | Verified | "SPARC", "spec before code" |

## skill-staff-engineer-v4 Detail

Flagship engineering skill. Progressive disclosure — SKILL.md is the entry point; sub-files load on demand.

Key capabilities:
- SCOPE_MODE gating (LITE / STANDARD / FULL)
- WSJF backlog prioritization
- Security-first: Zod, RLS, parameterized queries, OWASP LLM Top 10
- Agentic: tool output validation, MCP whitelist, prompt injection defense
- 6-persona audit loop as mandatory ship gate (P0 = no ship)
- CI/CD templates for GitHub Actions + Docker + Vercel/Cloudflare

## Cross-Reference by Use Case

**Security-First Builds:** skill-staff-engineer-v4 references/security-checklist.md, references/agentic-patterns.md, workflows/audit-loop.md

**Agentic/MCP Systems:** ai-agents-workflow, claude-agent-pack, skill-staff-engineer-v4/references/agentic-patterns.md

**Structured Methodology:** sparc-methodology-coach, skill-staff-engineer-v4/workflows/implement.md

**Observability and CI/CD:** skill-staff-engineer-v4/references/observability.md, references/cicd-template.md

**INT Lane:** int-ai-enablement-pm, int-data-analyst, skill-staff-engineer-v4

**Kinsley/Personal:** kyle-vibe-coding, accountability-buddy

## Versioning

Skills follow semver. Breaking trigger/field changes bump major. Additive content bumps minor. Fixes bump patch.

## Maintenance

- All skills require a SKILL.md with valid YAML frontmatter
- Reference and workflow files must appear in SKILL.md under required_reading
- To add a skill: copy governance/SKILL_TEMPLATE.md, fill fields, add entry here and in SKILLS-CATALOG.md