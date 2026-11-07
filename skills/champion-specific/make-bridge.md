---
name: make-bridge
description: Patterns for calling Claude from Make.com scenarios and calling Make.com from Claude-backed tools. Covers API setup, prompt caching across scenarios, error handling, structured output parsing, and the handoff boundary between Make's orchestration and Claude's reasoning.
tier: champion-specific
owner: your-team@your-org.example
status: stable
---

# Make Bridge

## Intent

Make.com is dominant workflow glue in many enterprises. Professional-services teams
use it for project scaffolding, marketing-ops teams for CRM/marketing-automation sync,
legal teams for fast-track approvals, partner teams for program automation. Meanwhile,
Claude (Projects, Code, API) is the reasoning layer more and more teams reach for.

The handoff between the two is where bugs live. This skill codifies the patterns that
work — and the ones that don't — so every Champion wiring Claude into a Make scenario
starts from the same baseline.

## When to use

- Adding a Claude step to a Make scenario for the first time
- A Make scenario with a Claude step that works intermittently, returns junk, or costs too much
- You want to trigger a Make scenario from Claude Code or a Claude Project
- You're choosing between "do this all in Claude" and "do this all in Make" (this skill
  will talk you out of both extremes)

## The handoff boundary

Before writing any Make → Claude or Claude → Make integration, decide where each side's
job starts and ends.

| Side | Good at | Bad at |
|---|---|---|
| **Make** | Multi-system orchestration, scheduling, data gathering, conditional branching on simple rules, webhook plumbing, keeping credentials | Open-ended reasoning, natural language understanding, generating quality content, judgement calls |
| **Claude** | Reading/writing natural language, making judgement calls, structuring unstructured data, rewriting / summarizing / drafting | Calling 8 different APIs in a single request, long-term state, deterministic retries, credential management |

**Rule of thumb**: Make does the plumbing, Claude does one job per call. Avoid having
Claude "also fetch from Salesforce, also write to Sheets, also notify Slack" in a
single prompt — split those into Make modules and use Claude only for the reasoning
step.

## Pattern 1 — Make → Claude (most common)

**Scenario shape**:
1. Trigger (schedule, webhook, Slack message, new record)
2. Make modules gather data from systems (SFDC, Confluence, Gong, Sheets)
3. Make module transforms data into a clean prompt input
4. HTTP module → Anthropic API (or AI Gateway if you have it)
5. Parse Claude's response
6. Make routes the result (Slack, Sheets, Jira, email)

### Required API setup

In your Make HTTP module:

- **URL**: `https://api.anthropic.com/v1/messages`
- **Method**: POST
- **Headers**:
  - `x-api-key: {{YOUR_KEY}}` — store in Make's built-in credential vault, not inline
  - `anthropic-version: 2023-06-01`
  - `content-type: application/json`
- **Body** (JSON):
  ```json
  {
    "model": "claude-sonnet-4-6",
    "max_tokens": 1024,
    "system": "You are a <role> for <your-org>. ... Reply only in the structured format described.",
    "messages": [
      { "role": "user", "content": "{{cleaned_input}}" }
    ]
  }
  ```

### Prompt caching (do this from day one)

Scheduled Make scenarios are the single best use case for prompt caching — the same
system prompt fires every run. Enable it:

```json
{
  "model": "claude-sonnet-4-6",
  "max_tokens": 1024,
  "system": [
    {
      "type": "text",
      "text": "<your system prompt + any reference docs>",
      "cache_control": { "type": "ephemeral" }
    }
  ],
  "messages": [
    { "role": "user", "content": "{{cleaned_input}}" }
  ]
}
```

For hourly+ schedules, use `"ttl": "1h"` inside `cache_control` to keep the cache warm
between runs. See `skills/universal/prompt-caching-starter.md` for the full pattern.

### Structured output (critical for Make)

Make can't reliably parse free-form Claude output. Force structured responses:

1. **JSON mode**: add `"response_format": {"type": "json_object"}` and be explicit in
   the system prompt about the exact schema.
2. **Parse with Make's JSON module**, not regex. If the response won't parse, route to
   an error branch.
3. **Always include a fallback field** like `"parseable": true` in the schema. If
   Claude returns a failure reason (e.g., input too vague), it can set `"parseable": false`
   and Make can route it to a human review queue.

### Error handling

Make's default error handling retries blindly. For Claude calls, be smarter:

- **429 (rate limit)**: retry with exponential backoff, max 3 retries
- **529 (overloaded)**: retry with backoff
- **400 (bad request)**: don't retry — this is a prompt bug; log and alert
- **401/403**: don't retry — this is an auth bug; alert immediately
- **Timeout**: retry once, then route to human review queue
- **Successful response but fails schema validation**: DO NOT retry — increment a counter,
  and if it happens >5% of runs, alert. The prompt is drifting.

## Pattern 2 — Claude → Make (trigger)

Useful when Claude Code or a Claude Project decides it needs to kick off a downstream
workflow (e.g., a support agent deciding to create a Jira ticket).

### Setup

1. In Make, create a scenario with a **Custom Webhook** trigger.
2. Secure the webhook:
   - Use Make's built-in secret token (attach as a query param or header)
   - Never rely on URL obscurity alone — treat the URL as a secret
3. Document the payload shape clearly, both for the Make scenario and the Claude caller.

### Claude-side

From a Claude Project or Claude Code with web access, POST to the webhook:

```bash
curl -X POST "https://hook.eu2.make.com/<your-hook-id>" \
  -H "Authorization: Bearer <secret>" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "create_ticket",
    "priority": "P2",
    "title": "...",
    "description": "..."
  }'
```

### What to never do

- **Never** let Claude generate the webhook URL from a template string and a customer-
  provided input. SSRF city.
- **Never** pass PII into a Make webhook without running it through `pii-guard` first.
- **Never** write a Claude prompt that says "if you decide to, you can call the webhook" —
  decisions to trigger external workflows need explicit human approval or a structured
  decision output the Make scenario can validate.

## Pattern 3 — Don't use Claude at all

Make alone is often enough. Signs you've over-engineered:

- The "Claude" step is just doing regex or template substitution
- The prompt is deterministic enough that a lookup table would do
- You're paying for tokens to reformat data from one known shape to another known shape

When Make has native modules for the job (date parsing, JSON reshaping, conditional
routing, string manipulation), use them. Save Claude for work that requires judgement.

## Monitoring

For every Make scenario with a Claude step:

1. **Log the prompt length, response length, and cache hit rate** (visible in Anthropic's
   `usage` object). Save to a Sheets row for trend analysis.
2. **Alert on schema violations** — if Claude's output fails your Make JSON module, that's
   a signal your prompt has drifted or the data has.
3. **Alert on unit-economics regressions** — if tokens/run doubles month-over-month,
   investigate. Usually it's a retrieval doc that grew too large.

## Anti-patterns

- Using a Make HTTP module with the credentials inline in the body (put them in Make's vault)
- Having one Claude call do "analyze AND write AND route AND notify" — split it
- Never enabling prompt caching on a scheduled run
- Using Claude to call Claude (build the tool use properly through the SDK instead)
- Building a Make scenario that kicks off at scale without a kill switch

## See also

- `skills/universal/prompt-caching-starter.md` — always enable caching on scheduled jobs
- `skills/universal/schedule-recurring.md` — decision guide for Make vs. Claude Code /loop vs. /schedule
- `skills/champion-specific/pii-guard.md` — run on data before it enters a Claude prompt
