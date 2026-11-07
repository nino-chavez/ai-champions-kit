---
name: prompt-caching-starter
description: How to enable and tune Anthropic prompt caching in any Claude API / SDK app. Dramatically cuts cost and latency for repeated-context bots (chatbots, RAG assistants, custom GPTs ported to Claude).
tier: universal
owner: your-team@your-org.example
status: stable
---

# Prompt Caching Starter

## Intent

Any team building a bot, RAG assistant, or Custom-GPT-ported-to-Claude is leaving 5–10x
cost and latency on the table if they haven't turned on prompt caching. This is the
single highest-ROI configuration change for API-backed AI work.

The pattern shows up everywhere — Custom GPTs with large context windows, customer-success
bots referencing dozens of SOPs, sales bots with structured frameworks. All of those
benefit disproportionately from caching.

## When to use

- You're building on the Anthropic SDK (Python or TypeScript)
- Your app sends the same system prompt, tool list, or document context on most calls
- You're about to deploy or have just deployed an API-backed bot
- You notice your bill is higher than you expected

Not relevant if: you're only using Claude.ai, Claude Projects, or Custom GPTs in ChatGPT —
those handle caching automatically or don't expose it.

## Instructions

### 1. Identify what's reusable

In your prompt, what's the same across calls?

- **System prompt** — almost always cacheable
- **Tool definitions** — almost always cacheable
- **Document context / RAG-injected knowledge** — cacheable if it doesn't change per turn
- **Few-shot examples** — cacheable

What's NOT cacheable: user messages, real-time data, personalization.

### 2. Add cache_control breakpoints

Anthropic supports up to 4 cache breakpoints per request. Place them at the **end** of
each cacheable block.

Python:
```python
response = client.messages.create(
    model="claude-sonnet-4-6",  # or latest
    max_tokens=1024,
    system=[
        {
            "type": "text",
            "text": "You are a support bot for ACME...",
            "cache_control": {"type": "ephemeral"},
        },
        {
            "type": "text",
            "text": LARGE_KB_DOCUMENT,
            "cache_control": {"type": "ephemeral"},
        },
    ],
    messages=[{"role": "user", "content": user_query}],
)
```

TypeScript:
```ts
const response = await client.messages.create({
  model: "claude-sonnet-4-6",
  max_tokens: 1024,
  system: [
    { type: "text", text: SYSTEM_PROMPT, cache_control: { type: "ephemeral" } },
    { type: "text", text: LARGE_KB, cache_control: { type: "ephemeral" } },
  ],
  messages: [{ role: "user", content: userQuery }],
});
```

### 3. Measure the hit rate

Every response includes `usage.cache_creation_input_tokens` and `usage.cache_read_input_tokens`.
A healthy deployment shows cache reads that dwarf writes after the first few requests.

```
cache_creation_input_tokens: 12800   # first call of a cache window — full cost
cache_read_input_tokens:     12800   # subsequent calls — ~10% of full cost
```

If you're not seeing cache reads, you probably have drift in the cached block (a dynamic
timestamp, user name, or session ID leaked in). Remove it or move it outside the cache.

### 4. Tune the cache window

Default TTL is 5 minutes. For low-traffic bots, pre-warm the cache with a keep-alive call,
or move to the 1-hour TTL (`"cache_control": {"type": "ephemeral", "ttl": "1h"}`).

## Expected gains

- **First call**: ~+25% tokens due to cache_creation overhead
- **Subsequent cached calls**: ~90% cheaper on the cached portion, ~85% faster TTFT

For a bot with 20k tokens of context and 200 calls/hour, typical savings are 70–85% on
input token cost and 2–3x on latency.

## Anti-patterns

- Don't cache per-user or per-session content — it will miss every time
- Don't cache below the minimum (1024 tokens for Sonnet, 4096 for Opus/Haiku under the older model) — it won't activate
- Don't put `cache_control` on every single block — you have 4 breakpoints; use them on logical boundaries
- Don't forget to monitor `cache_read_input_tokens` — untuned caching can silently cost more than no caching

## See also

- `skills/universal/bootstrap-context.md` — a good CLAUDE.md reduces the prompt you need
- `skills/champion-specific/gpt-context-refresher.md` — for keeping large context docs fresh
