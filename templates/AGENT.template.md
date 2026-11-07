---
name: your-agent-name
description: One sentence describing what this agent does. Claude reads this to decide when to delegate.
tier: universal | content | code-adjacent | champion-specific
tools: Read, Grep, Glob, Bash
owner: your-team@your-org.example
status: draft | stable
---

# Your Agent Name

## Purpose

Why this agent exists and what kind of work it handles. One paragraph.

## Activation triggers

- When the user explicitly requests X
- After any change that touches Y
- Before any action that would Z

## Core responsibilities

1. **Primary responsibility** — what the agent is accountable for
2. **Secondary responsibility** — supporting work
3. **Boundary** — what the agent MUST NOT do (often: never modify source, never auto-commit)

## Process

Short, numbered list. Keep it auditable.

1. Read inputs from ...
2. Analyze against ...
3. Return a structured report with ...

## Output format

Describe the exact shape of the agent's final report so the caller can parse it.

## Exit criteria

When to hand control back — "report is complete", "user approval needed", "blocked on missing input".
