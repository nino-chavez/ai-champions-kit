---
name: simplify
description: Reviews recently-changed code for unnecessary complexity, dead scaffolding, duplicated helpers, and premature abstraction — then fixes what it finds. Counters the natural entropy of AI-generated and vibe-coded codebases.
tier: code-adjacent
owner: your-team@your-org.example
status: stable
---

# Simplify

## Intent

A marketing-ops team vibe-coded a budget-tracking tool. A web team built a demand-gen
dashboard with AI assistance. An engineering team enabled a code-generation assistant
across the board. Each of those is valuable — and each compounds a recognizable entropy
pattern: helpers that are called once, abstractions for futures that never arrive,
error handling for conditions that can't happen, variables renamed to `_unused` instead
of deleted.

This skill is the cleanup pass. Run it before committing anything non-trivial, and
definitely before merging code you wrote with AI assistance.

## When to use

- Right before commit on any change of more than ~20 lines
- After an AI assistant (Claude Code, Codex, Cursor) scaffolds a feature
- When returning to code you wrote months ago and it feels heavier than you remember
- Before opening a PR on work that's been through multiple rounds of iteration

## Instructions

### 1. Scope the review

Only look at changed files, not the whole repo. Use `git diff` against the target branch.
Reviewing unchanged code wastes time and invites scope creep.

### 2. Check for these specific patterns

Walk through the diff and flag every instance of:

**Reuse**
- Is there an existing helper, hook, or utility in this repo that already does this?
- Was a similar block written in a sibling file recently? (Grep for the pattern.)

**Dead scaffolding**
- Interfaces with one implementation
- Abstractions introduced "for future flexibility" with no second caller
- Factory functions that return exactly one thing
- Comments like `// TODO: make generic` on code that isn't generic and doesn't need to be

**Unnecessary error handling**
- `try/catch` around code that literally cannot throw
- Fallback branches for conditions that would fail type-checking or validation upstream
- Input validation at internal boundaries when the same validation happens at the system boundary

**Over-eager type coupling**
- New types that duplicate existing types with one field changed
- Enums that have one value
- Type unions with a never branch

**Dead code**
- Unused imports
- Unused variables (especially `_unused` names — just delete)
- Unreferenced exports
- Commented-out blocks (git has history; the comment doesn't help)

**Unnecessary comments**
- Comments restating what the next line does (`// increment counter` above `i++`)
- Task-context comments (`// fixes issue #123`, `// added for the X flow`)
- Multi-line docstrings on functions that are clearly named and one screen tall

### 3. Apply the fixes

For each finding, make the smallest change that removes the issue:

- Replace with existing helper → call site changes only
- Dead scaffolding → inline the one caller, remove the abstraction
- Unnecessary try/catch → unwrap it
- Duplicate type → extend the existing one
- Commented-out block → delete

### 4. Re-run tests

Run whatever test command the project uses. If the project doesn't have tests, at least
type-check and lint.

### 5. Report the delta

```
SIMPLIFY REPORT
===============
Files changed:    N
Lines removed:    X (of which dead code: Y, dead scaffolding: Z)
Lines added:      A
Net:              -(X-A)

Summary:
  - Inlined 2 single-caller abstractions in src/lib/quote.ts
  - Replaced custom throttle with lodash.throttle (already imported elsewhere)
  - Removed 14 lines of unreachable error handling in handlers/payment.ts
  - Deleted 3 commented-out blocks

Tests: PASS
Typecheck: PASS
```

## Anti-patterns for the skill itself

- **Don't** refactor unchanged code. The scope is the diff.
- **Don't** introduce new abstractions while simplifying. That's the opposite of the job.
- **Don't** remove error handling that guards an external boundary (user input, network
  responses, file I/O) — only internal boundaries where correctness is already guaranteed.
- **Don't** delete comments that explain the *why* of a non-obvious choice. Delete
  comments that explain *what* the code does.

## See also

- `agents/code-adjacent/coding-standards-reviewer.md` — for convention compliance, separate from simplification
