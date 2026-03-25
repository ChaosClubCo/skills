---
name: create-subagents
description: Expert guidance for creating, configuring, and orchestrating Claude Code subagents using the Task tool and agent type definitions — enabling parallel execution, task delegation, isolated worktree environments, and multi-agent pipelines. This skill should be used when the user asks to create a subagent, build a custom agent type, use the Task tool, launch specialized agents, run tasks in parallel, delegate work to another agent, set up agent isolation with worktrees, understand how subagents communicate results back to the parent, configure agent descriptions, build multi-agent pipelines, chain agents together, spawn concurrent workers, or understand how agent sandboxing works. Also triggers on: how do I run tasks in parallel, spawn another agent, launch a subagent, how does the Task tool work, multi-agent workflow, agent handoff, delegate to a subagent, parallel agent execution, isolated agent environment, worktree agent, build a specialized agent, agent result handling, subagent communication, custom agent type, how to make Claude run two things at once, concurrent agent tasks, agent orchestration pattern, what is the Task tool, subagent vs main agent, isolation mode worktree.
license: Complete terms in LICENSE.txt
---

# Create Subagents

This skill provides expert guidance for creating, configuring, and using Claude Code subagents — specialized agent instances launched by a parent agent to execute tasks in parallel, in isolation, or with domain-specific capabilities.

## What Are Subagents?

Subagents are Claude instances spawned by a parent Claude instance using the **Task tool** (also called the Agent tool). They enable:
- **Parallelism**: Run multiple independent tasks concurrently
- **Specialization**: Launch agents with specific capabilities, tools, or prompts
- **Isolation**: Run agents in separate git worktrees so changes don't conflict
- **Delegation**: Break complex multi-step work into focused sub-tasks

## The Task / Agent Tool

The Task tool (named `Agent` in the Cowork context) launches a subagent with a given prompt and optional configuration:

```javascript
// Example Task tool invocation (from within a skill or system prompt)
Agent({
  description: "Run tests and fix failures",
  prompt: "Run the full test suite. For each failure, identify the root cause and fix it. Return a summary of changes made.",
  subagent_type: "general-purpose",  // optional: use a defined agent type
  isolation: "worktree"              // optional: run in isolated git worktree
})
```

## Isolation Modes

| Mode | Description | When to Use |
|------|-------------|-------------|
| None (default) | Shares workspace with parent | Read-only tasks, quick lookups |
| `"worktree"` | Creates a temporary git worktree | Any task that writes/modifies files |

When `isolation: "worktree"` is set:
- A clean copy of the repo is checked out in a temp branch
- The agent makes changes there without affecting the parent's workspace
- If changes are made, the worktree path and branch are returned so the parent can review/merge
- If no changes are made, the worktree is cleaned up automatically

## Custom Agent Types

Define agent types in the plugin's `agents/` directory. Each agent type has:

```yaml
# agents/code-reviewer.md
---
name: code-reviewer
description: Reviews code for security, performance, and correctness issues. Use for PRs, diffs, and file-level reviews.
tools:
  - Read
  - Grep
  - Glob
  - WebFetch
---

You are a senior code reviewer specializing in security and performance.
When reviewing code:
1. Check for OWASP Top 10 vulnerabilities
2. Identify N+1 query patterns
3. Flag missing error handling
4. Note test coverage gaps

Always provide: severity (critical/high/medium/low), file + line, explanation, fix.
```

## Parallel Agent Pattern

```markdown
# In your orchestrating prompt or skill:
Launch three agents in parallel:
1. Agent: "Audit src/api/ for security issues"
2. Agent: "Run all tests and collect failures"  
3. Agent: "Check dependencies for known CVEs"

Wait for all three, then synthesize their findings.
```

## Best Practices

1. Use `isolation: "worktree"` for any agent that writes files — prevents conflicts with the parent
2. Keep subagent prompts specific and self-contained — don't rely on parent context
3. Return structured summaries from subagents so the parent can synthesize efficiently
4. Limit parallel agents to ~5 at once to avoid rate limiting
5. Use specialized agent types for repeated tasks (code-reviewer, test-runner, etc.)
6. Handle the case where a subagent returns no changes (worktree cleanup confirms success)
