---
name: pii-guard
description: Pre-send PII and sensitive-data scanner. Call this before pasting any document, transcript, spreadsheet, or snippet into an AI tool. Flags Tier-2 data that needs redaction and Tier-3 data that must never enter AI at all.
tier: champion-specific
owner: your-team@your-org.example
status: stable
---

# PII Guard

## Intent

"Overcoming PII and generative AI use case barriers" is the single most common blocker
raised across AI Champion cohorts — surfaced again and again by people-ops, marketing ops,
legal, and revenue-ops teams.

This skill gives you a one-shot scan you can run on any content before it goes into a
Custom GPT, Claude Project, NotebookLM, or anywhere else. It pairs with
`templates/pii-policy.template.md` — if your team hasn't adopted a tiered policy yet,
start there first.

## When to use

- Before pasting a Gong transcript, Salesforce export, support ticket, or Looker
  dashboard into any AI tool
- Before uploading a file as Knowledge to a Custom GPT or Claude Project
- When reviewing content that an AI generated to make sure nothing PII-adjacent
  leaked back in
- In a Make.com scenario, as a step between "data gathered" and "sent to AI"

## Instructions

Claude: when this skill is invoked on a piece of content, do the following.

### 1. Classify the content against a four-tier policy

Reference `templates/pii-policy.template.md` if the calling project has it. Otherwise
fall back to:

- **Tier 0 — Public**: safe anywhere
- **Tier 1 — Internal**: enterprise AI tools only
- **Tier 2 — Restricted**: must be redacted first
- **Tier 3 — Prohibited**: never enters AI

### 2. Scan for the following patterns

For each pattern, report: line/context, snippet (redacted if Tier 3), tier, recommended action.

- Full names paired with an identifier (employer, title, email, contact)
- Email addresses (all — even "looks public" ones)
- Phone numbers (any format)
- Physical addresses
- Government IDs (SSN, passport, driver's license, national ID)
- Payment card numbers, bank accounts, routing numbers
- Access credentials (API keys, tokens, passwords) — even test/staging
- Deal values, contract terms, or pricing tied to a named customer
- Employee compensation, performance review notes, medical info
- Protected health data (HIPAA categories)
- MNPI / material non-public information
- Customer data under NDA or special-category GDPR

### 3. Return a structured report

Always use this exact structure so downstream automations can parse it:

```
PII GUARD REPORT
================

Overall tier: <0 | 1 | 2 | 3>
Safe to send to: <list of approved destinations>

Findings (N total):

1. Tier: 2
   Pattern: Email address
   Line/context: "...send the quote to jane.doe@acmecorp.com by Friday..."
   Recommended action: Redact to [CUSTOMER_EMAIL] before sending

2. Tier: 3
   Pattern: Employee compensation
   Line/context: [REDACTED — do not echo in output]
   Recommended action: Do not send to any AI tool. Handle manually.

...

Redacted version (if all findings ≤ Tier 2):
<<<
[paste redacted content here]
>>>
```

### 4. If any Tier 3 findings exist

Do not produce a redacted version. Instead, emit:

```
BLOCKED: This content contains Tier-3 data that cannot be remediated by redaction.
Handle manually. See templates/pii-policy.template.md for details.
```

## Expected output

A PII Guard Report, in the exact format above. Never prose.

## Anti-patterns

- **Never** echo Tier-3 data back in the report, even as a "what was found" example. Describe it, don't quote it.
- Never auto-send content to AI after scanning — return the report and let the human decide.
- Don't over-redact Tier-1 data — aggregated metrics and de-identified SOPs are usually fine for enterprise AI.
- Don't skip fields because they "look synthetic" — test data can still be real PII that slipped into a test set.

## Escalation

If a Champion disagrees with a classification, route to #legal-ai or the GRC rep in your
org. This skill encodes a conservative default; edge cases should be decided by humans.
