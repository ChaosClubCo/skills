---
name: doc-coauthoring
description: >
  Structured co-authoring workflow for technical and strategic documents — RFCs, ADRs, PRDs, one-pagers, strategy docs, proposals, and memos — using iterative refinement, context transfer, and reader validation techniques. This skill should be used when writing documentation, when you have rough notes that need to become a polished document, when drafting a proposal that must convince stakeholders, when a document keeps getting revised without progress, or when you need to think through a complex topic by writing about it. Also triggers on: RFC, ADR, architecture decision record, product requirements document, PRD, one-pager, strategy doc, proposal, co-write documentation, "help me write this", "turn my notes into a doc", draft a spec, technical writing, iterative document, document structure, writing workshop, "I don't know how to start this doc", "help me think through this", memo, executive brief, stakeholder document, design doc, project brief, decision doc, "make this readable", "my writing is unclear", "this doc is too long", narrative structure, document outline, "write a proposal for".
license: MIT
---

# Doc Co-Authoring

A structured workflow for writing documents that actually get read and acted on.

## The 4-Phase Workflow

### Phase 1: Context Dump

Tell me (in any order, any format):
- **What is this doc for?** (align the team, get approval, onboard new hires, record a decision)
- **Who reads it?** (eng lead, exec, customer, new hire)
- **What should they do after reading?** (approve, act, understand, contribute)
- **What do you already have?** (notes, bullets, prior art, relevant links)

I'll ask at most 3 clarifying questions.

### Phase 2: Structure First

Before writing prose, agree on structure.

**RFC / Proposal**
```
1. Summary (1-paragraph TL;DR)
2. Problem Statement
3. Proposed Solution
4. Alternatives Considered
5. Trade-offs
6. Implementation Plan
7. Open Questions
```

**ADR (Architecture Decision Record)**
```
1. Status (Proposed / Accepted / Deprecated)
2. Context
3. Decision
4. Consequences
5. Alternatives Rejected
```

**PRD / Spec**
```
1. Overview
2. Goals & Non-Goals
3. User Stories / Requirements
4. Design / Technical Approach
5. Success Metrics
6. Open Questions
7. Out of Scope
```

**One-Pager / Memo**
```
1. Situation
2. Recommendation
3. Rationale (3 bullets max)
4. Risks
5. Next Steps
```

### Phase 3: Draft Iteratively

- Start with the sections you know best
- Leave `[TBD]` markers for gaps
- Don't polish until structure is locked
- I'll flag unclear sections and suggest rewrites

### Phase 4: Reader Test

Before finalizing:
- [ ] Can someone unfamiliar with this topic understand the summary?
- [ ] Is the ask / decision / CTA clear by paragraph 2?
- [ ] Are all `[TBD]` sections resolved?
- [ ] Is the document the right length for its purpose?
- [ ] Are all claims supported (data, examples, or prior art)?

## Writing Principles

**Lead with the ask.** Don't bury the recommendation in paragraph 4.

**One idea per sentence.** If a sentence needs a comma and two clauses, split it.

**Active voice.** "The team will deploy" not "The deployment will be executed by the team."

**Kill filler.** "It is important to note that..." → delete. "In order to..." → "To...".
