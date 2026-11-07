---
name: gpt-context-refresher
description: Consolidates many source documents into the smallest number of Knowledge files that fit inside a Custom GPT's or Claude Project's context limits, and keeps them synced with the originals. Solves the "100+ SOPs, context caps at ~50 docs" problem.
tier: champion-specific
owner: your-team@your-org.example
status: stable
---

# GPT Context Refresher

## Intent

A pattern every revenue-ops / professional-services team with a doc-heavy bot hits:

> **Problem**: Custom GPT context for SOP-heavy internal assistants is painful to update —
> there are often 100+ SOPs and the context caps out at ~50 docs.
> **Solution**: Manually compile the SOPs into one master doc or several consolidated docs.
> **Challenge**: When 5 SOPs change, keeping the consolidated doc in sync is a major chore.
> **Idea**: Automate keeping individual source docs in sync via Make (or a cron job).

This skill codifies that pattern — consolidate, chunk, re-sync — so every team with a
doc-heavy bot can adopt it without reinventing.

## When to use

- You own a Custom GPT, Claude Project, or NotebookLM that references >20 source docs
- You hit an upload cap, a token cap, or the bot started "losing library" / "forgetting"
- You're migrating a Custom GPT to Claude Projects (good time to consolidate)
- You're watching a bot degrade over time even though no one explicitly changed it

## Instructions

### 1. Inventory the sources

List every source doc the bot currently uses. For each one capture:

- Source URL / path (Google Doc, Confluence page, repo file, etc.)
- Owner (who updates it)
- Volatility (updated daily / weekly / quarterly / rarely)
- Category (process, reference, FAQ, template, glossary)

Output as a table. Store it as `context-manifest.md` next to the bot definition.

### 2. Group by category and volatility

The consolidation strategy depends on both dimensions.

| Volatility | Strategy |
|---|---|
| **Rarely changes** (glossary, org chart, product taxonomy) | Consolidate into `reference.md` — one file, updated manually, rarely |
| **Monthly–quarterly** (process SOPs, playbooks) | Consolidate into `processes.md` per category — keep category groups ≤ 40k tokens |
| **Weekly or faster** (pricing, roadmap, FAQ) | Keep as individual files, set up automated sync |

### 3. Build consolidated files

For each consolidation target, produce a single Markdown file with this structure:

```markdown
# [Category] — consolidated

Last synced: <timestamp>
Sources:
- [Source 1 title](<url>) — owner, last modified
- [Source 2 title](<url>) — owner, last modified
...

---

## [Source 1 title]

<content of source 1>

---

## [Source 2 title]

<content of source 2>

---
...
```

The horizontal rules matter — they give the LLM a clean chunking boundary.

### 4. Wire the sync

Two recommended patterns:

**Make.com sync**:
1. Schedule trigger (hourly or daily)
2. For each source in `context-manifest.md`, check if `last modified > last synced`
3. If so, fetch the latest content, replace the section in the consolidated file
4. Update the `Last synced` timestamp
5. Re-upload the consolidated file to the Custom GPT / Claude Project

**Git-based sync** (if your sources are in repos or can be exported there):
1. Cron job pulls latest source content into a consolidated file
2. Commit the consolidated file
3. Claude Project / Custom GPT references the file via URL or re-upload

### 5. Add a freshness indicator

At the top of the consolidated file, include a freshness check the bot can reference:

```
> **Freshness**: Last synced 2026-04-17 09:00 UTC.
> If you're answering about anything that might have changed in the last 24h,
> say so explicitly and suggest the user verify against the source doc.
```

This gives the bot a reason to hedge when freshness matters, instead of confidently
answering with stale data.

## Expected output

- `context-manifest.md` — the source inventory
- One or more consolidated `.md` files under the token cap
- A sync mechanism (Make scenario, cron job, or documented manual process)
- A freshness indicator baked into each consolidated file

## Anti-patterns

- **Don't** consolidate across categories — mixing process SOPs with FAQ and glossary in
  one file destroys retrieval quality
- **Don't** re-consolidate on every sync — only rewrite the sections that changed; the
  rest of the file stays stable, which is better for caching and for bot stability
- **Don't** exceed ~40k tokens per consolidated file — past that, retrieval degrades and
  the bot starts missing things at the tail
- **Don't** skip the `Last synced` timestamp — without it, users have no way to know if
  an answer is current

## See also

- `skills/universal/prompt-caching-starter.md` — large consolidated files are the best
  possible input for prompt caching
- `skills/champion-specific/hallucination-scanner.md` — verify the bot's answers still
  map to the refreshed source after consolidation
