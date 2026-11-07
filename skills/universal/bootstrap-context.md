---
name: bootstrap-context
description: Create or improve the context file that Claude reads at the start of every session — CLAUDE.md for repos, Project Instructions for Claude Projects, System Prompt for Custom GPTs. This is the cheapest quality lift available.
tier: universal
owner: your-team@your-org.example
status: stable
---

# Bootstrap Context

## Intent

The single biggest accuracy gain for any Claude-based workflow is a well-written context
file. For Claude Code, that's `CLAUDE.md`. For Claude Projects, it's the project
instructions. For Custom GPTs, it's the system prompt + knowledge files.

Teams routinely report Custom GPTs "losing library" or "throwing errors" — often the root
cause is a thin or sprawling system prompt, not the tool itself.

## When to use

- Spinning up a new repo, Claude Project, or Custom GPT
- Inheriting a bot that's "acting weird" and you can't figure out why
- Migrating a Custom GPT to Claude Projects (the structure is similar, but tighter)
- After any major change to the team, stack, or data policy the bot serves

## Instructions

### 1. Start from the template

Copy `templates/CLAUDE.md.template` into the target location:

- Claude Code repo: `./CLAUDE.md` at the repo root
- Claude Project: paste into the Project Instructions field
- Custom GPT: paste into the Instructions field; attach files as Knowledge

### 2. Fill the six sections

Every good context file covers these. Skipping any of them is the usual cause of
"the bot doesn't understand what we do":

1. **What this is** — one paragraph, no fluff
2. **Stack / tools / integrations** — concrete names, not categories
3. **People** — owner, on-call, adjacent teams
4. **Conventions** — naming, commit style, review rules
5. **Data handling** — what's safe to share, what isn't (link your PII policy)
6. **Known gotchas** — honest landmines from past incidents

### 3. Add a "never do this" section

Negative instructions are disproportionately effective with LLMs. Three or four specific
"never" rules beat a paragraph of positive guidance.

Example:
```
- Never paste customer names into this GPT's conversation
- Never claim a feature ships without checking the roadmap file
- Never auto-approve a contract over $X
```

### 4. Keep it under 300 lines

If you're over 300 lines, you're probably dumping. Move reference material to linked
docs or (for Projects/GPTs) into Knowledge files. The context file should answer:
*what must the assistant know on turn 1 that it won't figure out on its own?*

### 5. Re-read it quarterly

Context files rot. Team changed, stack moved, a new integration came online. Put a
"last reviewed" date at the top and a quarterly review on the calendar.

## Expected output

- A filled-in CLAUDE.md / Project Instructions / GPT System Prompt
- An obvious quality lift in the next 3–5 conversations
- Fewer "why did it suggest that?" moments

## Anti-patterns

- Don't paste your whole wiki into a Custom GPT system prompt — it fills the window and
  degrades everything downstream. Attach it as Knowledge instead.
- Don't write aspirational process ("we will code-review everything") when the reality is
  different. Claude will try to enforce what you wrote and friction will surface.
- Don't use emoji, decorative headers, or ASCII art — they consume tokens and add nothing.
- Don't repeat instructions that live in your data sources. If the KB already says "X",
  don't restate "X" in the system prompt.
