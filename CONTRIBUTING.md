# Contributing to the AI Champions Kit

## When to contribute

- Your team built a skill or agent that would help other Champions
- You hit a gap in the kit and built the fix locally — let's share it
- You found a bug, unclear instruction, or out-of-date reference
- You want to add a real-world example under `examples/`

## Before you open a PR

1. **Use the templates.** Every new skill must use the frontmatter in
   `templates/SKILL.template.md`; every new agent uses `templates/AGENT.template.md`.
2. **Pick the right tier.** The kit's tiers are audience-based:
   - `universal` — relevant to every Champion
   - `content` — writers, editors, marketers, brand
   - `code-adjacent` — anyone editing code
   - `champion-specific` — fills a gap surfaced in real-world Champion work
3. **Read the neighbors.** Skim 2–3 existing files in the target tier. Match the
   heading style, voice, and structure. Don't introduce a new shape.
4. **Write the "Intent" section first.** If you can't explain *why* this skill should
   exist in 3–5 sentences, it probably shouldn't yet.
5. **Cite the real-world trigger** (a Slack thread, monthly-update question, ticket, or
   incident) that prompted the work. Concrete context is the whole reason this kit exists;
   don't strip it out, and don't invent one.

## Skill quality bar

A skill should:

- Solve one thing clearly — not three things vaguely
- Include concrete triggers, not just a description
- Have an explicit "Expected output" section
- Have an explicit "Anti-patterns" section
- Cross-reference sibling skills / agents where they pair naturally

A skill should NOT:

- Duplicate an existing skill (extend the existing one instead)
- Hard-code a specific team's voice or domain (use a template instead)
- Depend on a non-standard tool unless that's documented in the frontmatter
- Include PII, customer names, deal values, or MNPI — even in examples

## Agent quality bar

On top of the skill bar, an agent should:

- Have a clear boundary on what it will and won't do (the "Boundaries" section)
- Always return a structured report — never free-form prose as a final output
- Have an unambiguous "Ready to commit / ship / publish" line if applicable
- Never auto-modify source without explicit approval

## Review process

1. Open a PR into `main`
2. Fill in the `owner` field in your new file's frontmatter with a real point of contact
   (an email or Slack handle) so future contributors know who to ask
3. Tag at least one active user of the relevant tier as a reviewer
4. Address feedback; keep the PR focused on one skill/agent
5. Once merged, post the addition in your org's `#ai-champions` channel (or equivalent) so other Champions know it's available

## Updating existing skills/agents

- Bump the `status` if the change is material (draft → stable, or stable → deprecated)
- Preserve the original intent in the commit message
- If the skill/agent is widely used, note breaking changes at the top of the file and
  give adopters at least a week before removing the old behavior

## Deprecating

Mark `status: deprecated` in the frontmatter, add a `## Deprecated` section at the top
with the reason and the recommended replacement. Don't delete — Champions who rely on
it need a grace period to migrate.
