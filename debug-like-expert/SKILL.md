---
name: debug-like-expert
description: >
  Deep systematic debugging for complex, intermittent, and hard-to-reproduce bugs using structured investigation protocols. This skill should be used when standard troubleshooting fails, when an error only happens sometimes, when a bug exists in production but not locally, when you need root cause analysis rather than a quick patch, or when debugging feels random and you need a method. Use for race conditions, async timing issues, cascading failures, memory leaks, "works on my machine" failures, or any situation where jumping straight to code changes would likely miss the underlying cause. Also triggers on: intermittent bug, flaky test, production-only error, stack trace analysis, five whys, RCA, root cause analysis, hypothesis testing, bisect the bug, elimination method, reproduce the issue, minimal repro case, debug systematically, "it worked yesterday", "only happens sometimes", systematic investigation, narrow down the cause, add instrumentation, logging strategy for debugging, "I can't reproduce it", "something is wrong but I don't know where", race condition, memory leak, async bug.
license: MIT
---

# Debug Like an Expert

Activate methodical investigation protocol. Stop guessing. Start proving.

## Phase 1: Characterize the Bug

Before touching any code:

1. **Write down the exact observed behavior** — not your interpretation, the literal output/error
2. **Write down the expected behavior** — what *should* happen
3. **Identify the delta** — what changed between last-known-good and now (deploys, deps, config, data)

Key questions:
- Is this 100% reproducible or intermittent?
- What's the smallest input that triggers it?
- Does it happen in all environments or only some?
- Is it correlated with time, load, specific users, or specific data?

## Phase 2: Build a Hypothesis

Form a falsifiable statement:

> "I believe [X component] is causing [Y behavior] because [Z evidence]."

Rank hypotheses by likelihood × blast radius. Investigate highest-likelihood first.

**Common bug categories:**

| Category | Signals |
|---|---|
| Race condition | Intermittent, load-dependent, thread/async code |
| Off-by-one | Boundary input failures, array index errors |
| State mutation | Works first run, fails on repeat |
| Null/undefined | Crashes only on certain data shapes |
| Env mismatch | Works locally, fails in CI/prod |
| Dependency version | Started after dep upgrade |
| Cache invalidation | Stale data, works after cache clear |

## Phase 3: Prove or Disprove

Add the **minimum instrumentation** needed to test your hypothesis:

```js
// Targeted log — not console.log spam
console.log('[DEBUG checkout]', { userId, cartId, itemCount: cart.items.length });
```

Use binary search / bisect to narrow scope:
- Comment out half the code path — does the bug disappear?
- Test with half the data — does it disappear?
- Roll back one commit at a time until clean

**Never move to a fix before you can reliably reproduce the bug.**

## Phase 4: Fix and Verify

Once root cause is confirmed:

1. Write a failing test that reproduces the bug *before* fixing it
2. Apply the minimal fix
3. Verify the test passes
4. Check for sibling bugs (same pattern elsewhere in the codebase)
5. Document the root cause in the PR/commit message

## Phase 5: Prevent Recurrence

- Add regression test
- Add monitoring/alerting if the bug was observable in prod
- Update runbook if this is an operational failure mode
- Run a lightweight 5 Whys to surface systemic issues

## Debugging Checklist

- [ ] Can I reproduce the bug consistently?
- [ ] Do I have a written hypothesis about root cause?
- [ ] Have I checked logs, traces, and metrics?
- [ ] Have I isolated the smallest failing case?
- [ ] Have I verified my fix doesn't break related paths?
- [ ] Have I added a regression test?
