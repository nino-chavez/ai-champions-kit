---
name: schedule-recurring
description: Patterns for running Claude on a schedule — polling, daily digests, weekly audits. Covers Claude Code's /loop (in-session) and /schedule (cron-based, out-of-session), plus when to reach for Make.com instead.
tier: universal
owner: your-team@your-org.example
status: stable
---

# Schedule Recurring Work

## Intent

A common Champion question: *"Can I make Claude run scheduled tasks on CLI?"* The answer
is yes, and this skill explains how to pick the right mechanism.

Many real-world workflows are polls, digests, or audits — jobs that benefit from running
on a schedule rather than on-demand. Using the right primitive matters:

- Wrong tool = brittle, expensive, or never actually runs
- Right tool = set it up once, forget about it for months

## When to use

- You want "check the deploy every 5 minutes"
- You want a daily Slack digest of PRs or tickets
- You want a weekly audit of stale documents or SOPs
- You want an executive summary emailed every Monday at 7am

## Decision guide

```
In-session polling (loop until a condition is met)?
  → Use Claude Code /loop

Cron-style, runs without Claude Code open?
  → Use Claude Code /schedule (creates a remote trigger)

Multi-system orchestration (Salesforce + Marketo + Gmail + ...)?
  → Use Make.com, call Claude as one step via the AI Gateway or SDK

Just need a chat reminder at a fixed time?
  → Use Slack's built-in /remind, Google Calendar, or a scheduled Slack bot — not AI
```

## Instructions

### Option A — Claude Code `/loop` (in-session)

Best for: "keep checking until X happens" while you're actively working.

```
/loop 5m /check-deploy-status
```

or let Claude self-pace:

```
/loop  poll the build until it completes, then summarize failures
```

Stops when the condition is met or when you interrupt. Uses the current session's context
and cache.

### Option B — Claude Code `/schedule` (out-of-session)

Best for: "run this cron job against Claude Code without me being logged in".

Creates a remote trigger that executes on a cron schedule. You give it a repo,
a branch, and a prompt — it runs in a clean environment, commits work if needed, and
reports back.

```
/schedule create
  prompt: "Audit the #ai-champions Slack channel for unanswered questions older than 48h
           and post a digest to #ai-champions-digest"
  cron: "0 9 * * 1"        # every Monday 9am
  repo: commerce/ops
```

List with `/schedule list`, remove with `/schedule delete <id>`.

### Option C — Make.com with Claude step

Best for: "this workflow touches 4 systems and Claude is just one of them".

In a Make scenario:
1. Trigger (schedule, webhook, Slack event, etc.)
2. Gather data from system A, B, C
3. HTTP module → Anthropic API (or AI Gateway)
4. Parse result, route to system D

Keep the Claude prompt cached (`skills/universal/prompt-caching-starter.md`) — scheduled
jobs are the single best use case for caching.

## Monitoring

For any recurring job, build in:

1. **A heartbeat** — log that it ran, even if there was nothing to do
2. **A failure path** — where does the error go? (Slack channel, email, nothing?)
3. **A kill switch** — how does someone stop it at 2am if it goes rogue?

## Anti-patterns

- Don't use `/loop` for overnight jobs — it holds a session open
- Don't use `/schedule` for anything that needs low latency (it's batch, not real-time)
- Don't chain five Claude calls in a Make scenario when one call with tools can do it
- Don't schedule a job that doesn't do anything useful when nothing changed — it just
  produces noise that everyone learns to ignore
