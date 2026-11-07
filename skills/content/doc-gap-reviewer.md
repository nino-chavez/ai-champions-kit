---
name: doc-gap-reviewer
description: Structured second-pass review for any document before publication — flags logic gaps, ambiguous language, and internal inconsistencies.
tier: content
owner: your-team@your-org.example
status: stable
---

# Doc Gap Reviewer

## Intent

A pattern that keeps showing up in real-world Champion work — often pitched as a
"paste any document into Claude and get a structured list of gaps, unclear language,
and internal inconsistencies in under two minutes" tip:

> High-level review against three axes (gaps, ambiguity, inconsistency) catches the
> 80% of document issues that matter, fast, without rewriting the author's voice.

That pattern is genuinely good and generalizes well. This skill turns it into an
importable asset so any Champion — SOP author, PM writing a spec, a customer-success
lead drafting a strategic business review, a legal team drafting a vendor brief — can
run it the same way.

## When to use

- Before sending any SOP, playbook, brief, or report to a stakeholder or client
- Before publishing any customer-facing doc (help center, blog, sales collateral)
- After co-authoring with AI — this catches the "looks fine but says nothing" failure mode
- When inheriting an old doc that needs a freshening pass before reuse

Do NOT use this for pure fact-checking against sources — that's `hallucination-scanner`.
This skill is about the **internal quality** of the document itself.

## Instructions

### 1. Require inputs

- **The document** under review (pasted or attached)
- **Audience + intent** — "this is a Tier-1 strategic business review for Enterprise
  customers" or "this is an internal SOP for our solutions-engineering team". Without
  this, the review is noise.

If audience/intent is missing, ask for it before proceeding.

### 2. Review along three axes

Run three separate passes. Don't mix them — findings from different axes need
different fixes.

**Axis A — Logic gaps**
- Are all referenced items defined?
- Are prerequisites stated before they're needed?
- Are there unstated assumptions the reader must already know?
- Does the argument / process actually reach its stated conclusion?

**Axis B — Ambiguous language**
- Weasel words: *may*, *typically*, *generally*, *as needed*
- Undefined pronouns: *it*, *this*, *they* without a clear referent
- Numbers without units or context: "the limit is 100" — 100 of what?
- Vague verbs: *leverage*, *enable*, *support* — what does the reader actually do?

**Axis C — Internal inconsistency**
- Does section 3 contradict section 7?
- Does a term change meaning between sections?
- Do numbers in the summary match the numbers in the body?
- Does the title promise something the body doesn't deliver?

### 3. Prioritize

Group findings into tiers the author can act on:

- **Fix before sending** — logic gaps, contradictions, numbers that don't match
- **Worth fixing** — ambiguity that will definitely confuse the audience
- **Stylistic** — improvements that aren't blocking

### 4. Return a structured report

```
DOC GAP REVIEW
==============
Document: <filename or description>
Audience/intent: <as provided>

=== Axis A — Logic gaps ===
1. [Fix before sending] Section 2 uses "the threshold" before defining it. Define it in Section 1 or inline.
2. [Worth fixing] Conclusion assumes the reader already knows the ACV cutoff — state it.

=== Axis B — Ambiguity ===
1. [Worth fixing] "typically responds within a few hours" — commit to a number or remove.
2. [Stylistic] "leverage the platform" — say what the platform does.

=== Axis C — Inconsistency ===
1. [Fix before sending] Summary says "12 steps", body has 14. Fix one or the other.

=== Summary ===
Fix before sending: 2
Worth fixing: 3
Stylistic: 1

Ready to send: NO — address the 2 blocking items first.
```

### 5. Never rewrite the doc

The author owns the draft. The reviewer names issues; the author decides what to change.
If a Champion asks "just fix it for me", push back — a skill that silently rewrites docs
trains people to stop reading them.

## Expected output

A Doc Gap Review, in the exact format above. The "Ready to send" line must be YES or NO.

## Anti-patterns

- Don't comment on typos unless they affect meaning — that's a proofreader, not a gap reviewer
- Don't flag the same issue under multiple axes — pick the one that makes the fix clearest
- Don't accept "it's obvious from context" as a defense for ambiguity; the audience may not have that context
- Don't pad findings. If the doc is clean, the report is short. That's a feature.

## See also

- `skills/champion-specific/hallucination-scanner.md` — for factual verification against sources
- `agents/content/content-ux-reviewer.md` — for conversion/UX effectiveness (different lens)
- `agents/content/voice-tone-auditor.md` — for brand voice fit (different lens again)
