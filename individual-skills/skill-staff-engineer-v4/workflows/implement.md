<required_reading>
Load before executing any step:
- `references/security-checklist.md` — mandatory before Step 5
- `references/stack-defaults.md` — mandatory before Step 3
- `references/agentic-patterns.md` — mandatory if Step 6 applies
- `references/observability.md` — mandatory before Step 7
- `references/cicd-template.md` — mandatory before Step 8
</required_reading>

<process>

## Step 1 · Clarify (≤5 Questions or Explicit Assumptions)

Ask if ambiguous (one message, max 5 questions):
- Project lane? (Intinc / Customization Service / Kinsley / Personal)
- Target runtime? (Node LTS, Cloudflare Workers, Deno, Docker)
- Database + RLS? (Postgres/Supabase, DynamoDB, Redis)
- Auth provider? (Supabase Auth, Clerk, Auth0, custom)
- Deployment target? (Vercel, Cloudflare, Railway, AWS)
- Agentic components? (MCP server, subagents, n8n, RAG pipeline)
- SLOs? (latency p95, availability %, throughput req/s)
- Compliance? (SOC2, HIPAA, PCI-DSS, GDPR)

**Safe defaults — state explicitly if used:**
Runtime: Node.js LTS | DB: Postgres + Supabase RLS (multi-tenant assumed) | Auth: Supabase Auth | Deploy: Vercel + Cloudflare Workers | SLOs: 99.9%, <200ms p95 | Compliance: none (flag if PII in schema)

---

## Step 2 · WSJF Backlog (FULL mode only)

Produce a living WSJF table before architecture. Re-sort on each update.

| Feature / Task | User Value | Time Criticality | Risk Reduction | Job Size | WSJF |
|---|---|---|---|---|---|
| Example: Auth RLS | 8 | 5 | 9 | 3 | **7.33** |

WSJF = (User Value + Time Criticality + Risk Reduction) ÷ Job Size
Implement highest first. Archive tasks scoring <3.0.

---

## Step 3 · Stack Selection

Pros/cons table if 3+ options. Always cite version. See `references/stack-defaults.md` for decision examples and safe defaults.

---

## Step 4 · File & Module Plan (Tree + Annotations)

```
project/
├── src/
│   ├── agents/              # Agent loop handlers
│   │   ├── orchestrator.ts  # Primary agent, maintains context
│   │   └── subagents/       # Isolated pure-function subagents
│   ├── mcp/                 # MCP server + tool definitions
│   ├── lib/
│   │   ├── auth.ts          # JWT verify, RLS context injection
│   │   ├── db.ts            # DB client + RLS enforcement
│   │   ├── validation.ts    # Zod schemas — all inputs land here
│   │   ├── observability.ts # PostHog + Sentry + traceId injection
│   │   └── context.ts       # Context window management + compression
│   ├── components/          # Frontend — typed, hydration-safe
│   └── app/api/             # Routes — all auth-gated
├── tests/
│   ├── unit/
│   ├── integration/
│   └── agents/              # Agent determinism + output validation tests
├── .github/workflows/ci.yml
├── .env.example
└── README.md
```

---

## Step 5 · Core Implementation

Load and apply `references/security-checklist.md` before writing any code.

**Code quality standards:**
- TypeScript strict mode
- Errors: Cause → Fix → Retry — never `throw new Error("failed")`
- Logging: structured JSON with `{ traceId, userId, requestId, timestamp }`
- No `console.log` in production — use structured logger

**Standard error pattern:**
```typescript
try {
  const result = await operation();
  return result;
} catch (error) {
  logger.error('Operation failed', {
    cause: error instanceof Error ? error.message : String(error),
    context: { userId, requestId, traceId },
  });
  throw new AppError('Unable to complete. Please retry.', {
    cause: error, retry: true, code: 'OP_FAILED',
  });
}
```

---

## Step 6 · Agentic Systems (When Applicable)

Apply when request involves agents, MCP, orchestration, or AI pipelines.

Load `references/agentic-patterns.md` — it contains:
- Agent architecture decision guide (single / primary+subagents / multi-agent / n8n)
- Context engineering rules
- MCP server design pattern
- Structured output contracts
- ReAct loop security pattern
- Full threat matrix + defense implementation

**Default: single agent. Escalate only when parallelism is provably required.**

---

## Step 7 · Observability Pack (STANDARD + FULL — Non-Negotiable)

Load `references/observability.md` for full implementation.

Core checklist:
- [ ] Every request has a `traceId` propagated through all services + agent calls
- [ ] Sentry: errors + agent failures with `{ userId, traceId, agentId }` context
- [ ] PostHog: user events + agent completions + tool call counts
- [ ] LLM token usage logged per call (model, promptTokens, completionTokens, costEstimate)
- [ ] Alert thresholds: p95 latency >500ms, error rate >1%, token burn >$X/day

---

## Step 8 · CI/CD + Documentation Pack

Load `references/cicd-template.md` for full yaml, README template, .env.example, and AGENTS.md template.

---

## Step 8.5 · Audit Loop (Ship Gate)

Load and execute `workflows/audit-loop.md`. Required before every merge, deploy, or hand-off.

---

## Completion Output (STANDARD + FULL)

End with 3-paragraph, 4-sentence **Progress & Next Steps**:
- Para 1: What was delivered
- Para 2: Quality gates passed + audit loop summary (P0/P1/P2 counts)
- Para 3: Next steps + open questions

---

## Self-Critique (Always Last)

```
3 Weaknesses + Patches:
1. Weakness: [gap] → Patch: [concrete, implementable fix]
2. Weakness: [gap] → Patch: [concrete, implementable fix]
3. Weakness: [gap] → Patch: [concrete, implementable fix]

Gaps / Blindspots / Unknown Unknowns:
- What I don't know: [scale, compliance, third-party limits not modeled]
- Unvalidated assumptions: [perf at >10K concurrent, agent behavior under adversarial input]
- Unknown unknowns: [regulatory changes, model drift, novel attack vectors]
```

</process>
