---
name: code-auditor
description: >
  Comprehensive codebase security and quality audit covering OWASP vulnerabilities, technical debt, architecture health, and maintainability scoring. This skill should be used when performing a security review before launch, when checking for hardcoded secrets or API keys, when scanning for injection vulnerabilities (SQL, XSS, command injection), when assessing technical debt accumulation, when preparing for a compliance or SOC2 review, or when a codebase feels messy and needs a structured health check. Use when asked to "audit this code", "is this secure", "find the tech debt", "review before we ship", or "what's wrong with this codebase". Also triggers on: OWASP Top 10, hardcoded credentials, SQL injection, XSS vulnerability, CSRF, authentication flaws, authorization bypass, insecure deserialization, dead code removal, cyclomatic complexity, code smell, pre-launch review, dependency vulnerability, secrets scanning, privilege escalation, insecure defaults, input validation audit, error handling gaps, code health score, refactor candidates, technical debt inventory, security posture review, "is this production ready", N+1 query, memory leak, missing error handling.
license: MIT
---

# Code Auditor

Systematic codebase analysis across six dimensions.

## Audit Dimensions

| Dimension | What We Check |
|---|---|
| **Security** | OWASP Top 10, secrets, auth/authz, injection, deps |
| **Architecture** | Coupling, cohesion, layering violations, circular deps |
| **Code Quality** | Complexity, duplication, naming, error handling |
| **Performance** | N+1 queries, blocking I/O, memory leaks, inefficient loops |
| **Testing** | Coverage, test quality, missing edge cases |
| **Maintainability** | Documentation, dead code, dependency freshness |

## Security Checklist (OWASP-Aligned)

**Injection**
- [ ] All DB queries use parameterized statements / ORM (no string concat)
- [ ] Shell commands sanitize user input
- [ ] Template rendering escapes output (XSS prevention)

**Authentication & Session**
- [ ] Passwords hashed with bcrypt/argon2/scrypt (not MD5/SHA1)
- [ ] JWT secrets are strong and rotated
- [ ] Session tokens invalidated on logout
- [ ] Rate limiting on auth endpoints

**Secrets & Config**
- [ ] No API keys, tokens, or passwords in source code
- [ ] `.env` files in `.gitignore`
- [ ] Secrets loaded from environment or vault

**Authorization**
- [ ] Every endpoint checks user permissions (no IDOR)
- [ ] Admin routes protected
- [ ] Row-level security for multi-tenant data

**Dependencies**
- [ ] No packages with known CVEs (`npm audit`, `pip-audit`, `trivy`)
- [ ] Dependencies pinned to exact or minor versions

## Code Quality Signals

**High Complexity** — functions > 20 lines, cyclomatic complexity > 10, nested conditionals 3+ levels deep

**Duplication** — same logic in 3+ places (candidate for extraction)

**Dead Code** — unreachable branches, unused exports, commented-out blocks > 10 lines

**Error Handling** — bare `catch` blocks, swallowed errors, no logging on failure paths

## Architecture Health

- Layering violations (UI calling DB directly, etc.)
- God objects / modules doing too many things
- Circular dependencies
- Missing abstraction boundaries

## Audit Report Format

```
## Audit Summary
Overall Health: [GREEN / YELLOW / RED]
Critical Issues: X
Warnings: Y
Suggestions: Z

## Critical (Fix Before Ship)
1. [Issue] — [Location] — [Risk] — [Fix]

## Warnings (Fix Soon)
...

## Suggestions (Backlog)
...
```

## Scope Options

- **Quick** (30 min): Security checklist + obvious smells, no deep dive
- **Medium** (2 hrs): Full security + architecture + top tech debt items
- **Complete** (4+ hrs): All dimensions, per-file complexity scoring, dependency tree audit
