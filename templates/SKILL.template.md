---
name: your-skill-name
description: One sentence describing what this skill does and when it should trigger.
tier: universal | content | code-adjacent | champion-specific
owner: your-team@your-org.example
status: draft | stable
---

# Your Skill Name

## Intent

Why this skill exists. What problem it solves. Who asked for it (link to the monthly
update, Slack thread, or ticket that prompted it if possible).

## When to use

Concrete triggers. Prefer "when X happens" over abstract descriptions.

- When a Champion drafts content before pasting it into a public AI tool
- When reviewing a Custom GPT response that cites facts
- When a document is about to be published externally

## Instructions

Step-by-step guidance Claude should follow when this skill loads. Be explicit about
inputs, outputs, and what not to do.

1. First, do X.
2. If condition Y, do Z instead.
3. Always return the result as a structured list, not prose.

## Expected output

Describe the shape of the response so users know what to expect.

## Anti-patterns

What this skill should never do.

- Never modify the user's source document directly
- Never claim a fact is verified without a citation
