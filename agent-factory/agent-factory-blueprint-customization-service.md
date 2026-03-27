# Agent Factory Blueprint — Customization Service
**Version:** 1.0
**Date:** 2026-03-25
**Lane:** CS (AI Customization Service)
**Stage:** POC → Production
**Revenue Target:** $300K–$500K Y1 | Margins: 50–80%

---

## Overview

The Agent Factory is the repeatable delivery engine behind the Customization Service. It produces AI agents and automation workflows for B2B SaaS and tech clients in 4–8 week POC engagements. Each engagement ships a working, scoped agent system — not a prototype — using a fixed stack and templated architecture.

The factory separates concerns into two layers:

- **Brain** — RAG/memory layer (NotebookLM or Supabase + pgvector). Holds client knowledge: docs, SOPs, product data, historical decisions.
- **Hands** — Execution layer (Claude + n8n). Reads from the Brain, takes action via tools, and produces outputs or triggers downstream workflows.

---

## Core Architecture

```
Client Knowledge Sources
        |
        v
  +-------------+
  |    BRAIN    |  <- Supabase (pgvector) or NLM export
  |  RAG/Memory |
  +------+------+
         | retrieval
         v
  +-------------+
  |    HANDS    |  <- Claude (claude-sonnet-4-6) via n8n
  |  Execution  |
  +------+------+
         | tool calls
         v
  +----------------------------------------+
  |              Tool Layer                |
  |  Slack | Email | CRM | Docs | APIs    |
  +----------------------------------------+
         |
         v
  +-------------+
  |   Outputs   |  <- Drafted content, logged actions, triggered workflows
  +-------------+
```

---

## Standard Stack

| Layer | Tool | Notes |
|-------|------|-------|
| Orchestration | n8n (self-hosted or cloud) | Primary workflow engine |
| LLM | Claude (claude-sonnet-4-6) | Via Anthropic API |
| Memory/RAG | Supabase + pgvector | Multi-tenant, RLS enforced |
| Auth | Supabase Auth | Per-client isolation |
| Frontend (if needed) | Vercel | Next.js or static |
| Payments | Stripe | POC to retainer billing |
| Analytics | PostHog | Agent usage + funnel |
| Email | Resend | Transactional + agent notifications |
| Edge/Cache | Cloudflare + Redis | Rate limiting, session cache |
| Version Control | GitHub | All agent configs + workflows |

---

## Agent Taxonomy (45 Products)

Agents are grouped into five families. Each family has a standard template and shared tool set.

### 1. Research & Synthesis Agents
- Competitive intelligence monitors
- Document summarizers (SOPs, contracts, reports)
- Meeting note processors
- Customer feedback synthesizers

### 2. Outreach & Communication Agents
- Personalized email drafters (CRM-aware)
- Follow-up sequence managers
- Slack digest and broadcast writers
- Proposal and deck drafters

### 3. Operations & Triage Agents
- Support ticket routers and responders
- Incident classifiers
- Onboarding workflow runners
- SLA monitors

### 4. Data & Reporting Agents
- Weekly metric digests
- Pipeline health summaries
- Anomaly detectors (PostHog, CRM)
- Executive briefing generators

### 5. Knowledge & Training Agents
- Internal KB writers (from resolved tickets)
- Onboarding guide generators
- Policy lookup responders
- Training content drafters

---

## POC Engagement Structure

**Duration:** 4–8 weeks
**Scope:** 1–3 agents from a single family
**Deliverable:** Live agent in client environment + runbook

### Phase 1 — Discovery (Week 1)
- Map client knowledge sources (docs, CRM, Slack, email)
- Identify highest-value agent candidate (WSJF scoring)
- Define success metric (time saved, tickets deflected, deals influenced)
- Confirm stack access and auth requirements

### Phase 2 — Brain Setup (Weeks 1–2)
- Ingest client knowledge into Supabase pgvector
- Configure RLS for client tenant isolation
- Test retrieval quality against 20 real queries
- Gate: retrieval precision >= 80% before proceeding

### Phase 3 — Agent Build (Weeks 2–4)
- Configure n8n workflow for agent logic
- Wire Claude with system prompt + tool definitions
- Implement tool connections (Slack, email, CRM, etc.)
- Unit test each tool call path
- Gate: all tool calls deterministic before live testing

### Phase 4 — Validation (Weeks 4–6)
- Run agent in shadow mode alongside human process
- Measure output quality vs. baseline
- Capture edge cases and failure modes
- Fix and re-test

### Phase 5 — Handoff (Weeks 6–8)
- Deploy to client n8n instance or managed environment
- Write runbook (trigger -> process -> output -> escalation path)
- Train 1–2 client operators
- Set PostHog dashboards for agent health monitoring
- Transition to retainer or next engagement

---

## Security Model

Every agent deployment enforces these constraints:

| Control | Implementation |
|---------|----------------|
| Tenant isolation | Supabase RLS — agents can only read their client data |
| Secrets management | n8n credentials store — never in prompts or logs |
| Input validation | All user/external inputs sanitized before passing to Claude |
| Output review gate | High-stakes outputs require human-in-the-loop approval |
| Audit trail | Every agent action logged to Supabase with timestamp + output hash |
| Rate limiting | Cloudflare + Redis — per-client token budget enforced at API layer |
| Prompt injection defense | Untrusted content wrapped in XML delimiters, never interpolated raw |

---

## Pricing Model

| Tier | Scope | Price | Margin |
|------|-------|-------|--------|
| POC Sprint | 1 agent, 4 weeks | $15K–$25K | ~70% |
| Full Engagement | 2–3 agents, 8 weeks | $40K–$75K | ~65% |
| Retainer | Ongoing ops + 1 new agent/quarter | $8K–$15K/mo | ~75% |
| Platform License | Self-serve agent templates | TBD | ~85% |

---

## Observability Requirements

Every shipped agent must have:

1. **Trigger log** — what fired the agent and when
2. **Context log** — what was retrieved from the Brain
3. **Action log** — what tool calls were made and their results
4. **Output log** — what was produced (content, action taken)
5. **Error log** — failures with classification (retrieval miss, tool error, LLM refusal)
6. **PostHog event** — `agent_run_completed` with duration, token count, and outcome

---

## Failure Modes & Mitigations

| Failure | Likelihood | Mitigation |
|---------|-----------|------------|
| Retrieval miss (wrong context) | Medium | Retrieval precision gate in Phase 2 |
| Tool call failure (API down) | Low | Retry logic + fallback notification |
| Prompt injection via user input | Low | XML delimiter wrapping |
| Hallucinated tool arguments | Medium | JSON schema validation on all tool outputs |
| Client data leakage across tenants | Low | RLS enforced at DB layer, tested in Phase 2 |
| Agent runs without oversight on high-stakes action | Medium | HITL gate required for all write operations in V1 |

---

## Reuse & Repeatability Standards

To maintain 50–80% margins, every component must be reusable:

- **System prompts** — versioned in GitHub, parameterized by client context
- **n8n workflow templates** — per agent family, imported and configured per client
- **Supabase schema** — single multi-tenant schema, client scoped via RLS
- **Runbook template** — fill-in-the-blank format, generated from agent config
- **Onboarding checklist** — standard 12-step client setup doc

New engagements reuse >= 70% of existing components. Net-new build is scoped to client-specific tool connections and knowledge ingestion only.

---

## Open Questions

- [ ] Which of the 45 products are template-ready vs. require custom build?
- [ ] What is the minimum viable Brain for clients with no structured knowledge base?
- [ ] Retainer pricing: per-agent vs. platform access vs. token budget?
- [ ] When does the factory need a self-serve onboarding layer (no white-glove)?

---

## References

- Stack: Claude + n8n + Supabase + Vercel + GitHub + Stripe + PostHog + Resend + Cloudflare + Redis
- Lane: CS (D:\03_Development\CustomizationService\)
- Related: intake/proposal-studio/cluster-b-brain-hands-handoff.md
- Related: output/proposal-studio/cs-model-definition.md
