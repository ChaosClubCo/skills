---
name: review-implementing
description: >
  Process and implement code review feedback systematically — addressing reviewer comments, resolving PR discussions, applying nits, and handling multi-reviewer change requests without missing items. This skill should be used when you have PR feedback to work through, when a reviewer has left comments you need to implement, when resolving GitHub review threads, when addressing requested changes before merge, or when batch-implementing a list of review suggestions. Also triggers on: PR feedback, pull request comments, reviewer requested changes, address review, resolve discussions, apply nit, implement suggestions, "fix the PR comments", "address reviewer feedback", "apply these changes from review", "make the changes they asked for", code review follow-up, LGTM blockers, failing review checklist, "what did the reviewer want", batch implement review comments, close review thread, re-request review, "respond to PR feedback", review-driven refactor, review suggestions to implement.
license: MIT
---

# Review Implementing

Systematically work through code review feedback without missing items or creating regressions.

## Workflow

### Step 1: Triage All Comments

Before touching code, read every comment and categorize:

| Category | Examples | Action |
|---|---|---|
| **Must fix** | Security issue, wrong behavior, test failure | Fix before merge |
| **Should fix** | Style, naming, simplification | Fix, or explain why not |
| **Nit** | Minor style preferences | Fix quickly or acknowledge |
| **Question** | "Why did you do X?" | Answer in thread |
| **Praise** | "Nice approach!" | Acknowledge (no code change) |

### Step 2: Group by Scope

Batch related changes together to avoid thrashing files:

```
Pass 1: Rename/refactor changes (highest churn)
Pass 2: Logic fixes
Pass 3: Test additions
Pass 4: Nits and comments
```

### Step 3: Implement Systematically

For each comment:

1. Read the comment fully — including any follow-up replies
2. Understand the *intent*, not just the surface suggestion
3. Make the change (or document why you won't)
4. Mark the thread resolved
5. Leave a reply explaining what you did if non-obvious

**For complex feedback:**
> "I see you want to extract this into a utility — I did that in `src/utils/format.ts` and updated all three call sites."

### Step 4: Self-Review Before Re-Requesting

Before pushing and re-requesting review:

- [ ] Every "Requested changes" comment has been addressed or replied to
- [ ] No new unintended changes snuck in (check the diff)
- [ ] Tests still pass
- [ ] No `console.log` debug statements left in
- [ ] Commit message updated if the approach changed significantly

### Step 5: Reply and Re-Request

Post a summary comment:

```
Addressed all feedback:
- Extracted validation logic to `validateUser()` as suggested
- Added error handling for the null case (see commit abc123)
- Left a note on the caching question — happy to discuss if you want a different approach

Re-requesting review.
```

## Handling Disagreements

If you disagree with a reviewer's suggestion:

1. Implement their suggestion in a separate commit (make it easy to revert)
2. OR explain your reasoning directly in the thread with evidence
3. Don't silently ignore — always reply

Template: *"I considered this approach, but [reason]. I went with [your approach] because [evidence/tradeoff]. Happy to change if you feel strongly."*

## Common Mistakes to Avoid

- Fixing the symptom but not the root cause the reviewer identified
- Making unrelated changes in the same commit (muddies the review)
- Resolving threads without actually addressing the comment
- Missing a comment buried deep in a long thread
