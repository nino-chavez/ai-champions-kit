# Example: Migrating a Custom GPT to Claude Projects

Real-world pattern for teams who built a Custom GPT in ChatGPT — a sales-discovery
assistant, an SOP-heavy internal helper, a sales-methodology framework GPT, a
content-marketing blog bot — and want to move it (or mirror it) in Claude Projects.

## Why move (or mirror)

- Claude's context window holds more source material without retrieval-quality drop-off
- Better traceability when the "GPT" becomes part of a Make.com pipeline or a Claude Code project
- Prompt caching is explicit and measurable
- One consolidated source of truth for the prompt + knowledge files — easier to version and review

You don't have to pick one. Many teams run both, use whichever tool the situation calls for, and converge on one once they see the usage pattern.

## Before you start

Install the kit universal tier:

```bash
/path/to/ai-champions-kit/install.sh --tier universal
/path/to/ai-champions-kit/install.sh --tier champion
```

You'll use three skills during the migration:

- `bootstrap-context` — shapes the Project Instructions
- `gpt-context-refresher` — consolidates the GPT's Knowledge files
- `pii-guard` — scans everything before it enters the new tool

## Step-by-step

### 1. Inventory the existing GPT

For the source Custom GPT, record:

- **System prompt** (copy it verbatim)
- **Knowledge files** (list all, with upload dates and owners)
- **Tools / actions** (if any)
- **Conversation starters** (the suggested prompts shown in ChatGPT's UI)
- **Usage stats** (monthly active users, typical questions, known failure modes)

Save this as `migration-inventory.md` next to your new Project.

### 2. Run the system prompt through `bootstrap-context`

Most Custom GPT system prompts grew organically and carry 2–3 years of cruft. Run the
bootstrap-context skill to refactor it into the 6-section structure:

- What this is
- Stack / tools
- People
- Conventions
- Data handling
- Known gotchas
- (Plus) Never-do rules

Expect to cut the word count by 30–60%. That's a win, not a loss — the new version will
be more consistent.

### 3. Run Knowledge files through `gpt-context-refresher`

Custom GPTs cap at ~20 files and lose retrieval quality well before that. Consolidate
per category:

- All SOPs → `processes.md`
- All reference / glossary → `reference.md`
- All product docs → `product.md`
- High-volatility (pricing, roadmap) → leave as separate small files and set up a sync

Each consolidated file includes the `Last synced` indicator so the bot can hedge when data might be stale.

### 4. Scan everything through `pii-guard`

Before uploading anything to Claude Projects, run `pii-guard` on:

- The revised system prompt
- Every consolidated knowledge file
- Sample conversations from the source GPT (these sometimes contain redacted-but-not-really customer names)

Handle Tier-2 findings (redact), stop on Tier-3 findings (don't upload, escalate).

### 5. Create the Claude Project

- Name and describe the project (keep the same name as the GPT if users know it — e.g., "[YourBotName] (Claude)")
- Paste the refactored system prompt as Project Instructions
- Upload the consolidated Knowledge files
- Add the 3–5 best conversation starters from the GPT's stats

### 6. Run a parallel evaluation

For one week, run 10–20 real questions against both the Custom GPT and the new Claude
Project. For each, record:

- Did the answer match?
- Which felt better? Why?
- Did either hallucinate? (Run `hallucination-scanner` to verify.)

This gives you data for the "should we switch, mirror, or retire the GPT?" decision.

### 7. Decide and communicate

Three possible outcomes:

- **Switch** — retire the Custom GPT, point users to Claude Project (update any doc that mentions the GPT)
- **Mirror** — keep both; the GPT handles lightweight chat, the Claude Project handles deep work
- **Stay** — keep the Custom GPT; migration wasn't worth it for this use case

All three are valid. The migration itself is the win — you now have a versioned, documented, reviewable AI asset either way.

## Common gotchas

- **Actions / tools don't port 1:1**. If the Custom GPT calls external APIs, you'll need
  Make.com or the Anthropic SDK with tool-use. Plan that separately.
- **Conversation starters** in Claude Projects are less prominent than in ChatGPT.
  Highlight them in your team's intro doc.
- **Image/PDF handling** behaves differently. Test your real workflows, not just text.
- **Expect a short regression period**. Users who have muscle memory for the Custom GPT
  need a few days to learn the new one even if it's objectively better.

## See also

- `skills/universal/bootstrap-context.md`
- `skills/champion-specific/gpt-context-refresher.md`
- `skills/champion-specific/pii-guard.md`
- `skills/champion-specific/hallucination-scanner.md`
