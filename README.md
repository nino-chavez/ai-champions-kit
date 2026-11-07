# AI Champions Kit

A shared library of **Claude Code skills and subagents** for AI Champions — anyone
driving AI adoption inside a team, function, or company. Copy what you need into any
project, repo, or Claude Project and go.

**Inventory**: 10 skills, 5 subagents, 5 starter templates, 1 end-to-end migration example.

## What is a "skill" and what is a "subagent"?

- A **skill** is an instructional markdown file Claude Code loads on demand. It teaches
  Claude how to do one specific thing well (e.g., run a PII scan, enable prompt caching,
  audit brand voice). Skills live in `.claude/skills/` and become available as soon as
  they're there.
- A **subagent** is a delegated worker Claude Code can hand a scoped job to. Subagents
  run in their own context and report back — great for bounded tasks, independent reviews,
  or anything that would otherwise flood the main conversation with noise. They live in
  `.claude/agents/`.

After running the installer, open Claude Code in the target project and the skills/
subagents are immediately discoverable — no restart, no config.

## Who this is for

Anyone using Claude Code, Custom GPTs, Claude Projects, or building internal AI workflows —
whether you're an engineer, a professional-services lead, a brand/marketing lead, or a
non-coder in legal, people-ops, or revenue-ops. The kit is tiered so you only pull what's
relevant to your role.

## What's in the box

```
ai-champions-kit/
├── skills/
│   ├── universal/            Always useful — start here
│   ├── content/              Writing, voice, docs, reviews
│   ├── code-adjacent/        For vibe-coders and engineers
│   └── champion-specific/    Fills the gaps AI Champions repeatedly surface (PII, hallucinations, GPT context caps, doc drift, Make.com integration)
├── agents/                   Delegated workers (same tiering)
├── templates/                Starter files: CLAUDE.md, brand-voice, PII policy
├── examples/                 Real migration patterns (e.g., Custom GPT → Claude Projects)
└── install.sh                Copies selected tiers into your project's .claude/ directory
```

## Install

Clone or download this repo, then from the target project directory:

```bash
# Universal skills + agents only — best first step
/path/to/ai-champions-kit/install.sh --tier universal

# Add content tools (brand, creative, marketing, legal, people-ops)
/path/to/ai-champions-kit/install.sh --tier content

# Add code tools (ops, web dev, AI ops, anyone coding with AI)
/path/to/ai-champions-kit/install.sh --tier code

# Add Champion-specific gap-fillers (recommended for everyone)
/path/to/ai-champions-kit/install.sh --tier champion

# Everything
/path/to/ai-champions-kit/install.sh --tier all
```

The installer copies `.md` files into `./.claude/skills/` and `./.claude/agents/`. It never
overwrites existing files without `--force`.

## Start here by role

Every row below is a list of tiers to install. Run the installer once per tier
(`install.sh --tier <name>`), or install everything with `--tier all`.

| Role | Tiers to install | First skills to read |
|---|---|---|
| **Any Champion** | `universal`, `champion` | `prompt-caching-starter`, `pii-guard`, `hallucination-scanner` |
| **Brand / Creative / Content** | `universal`, `champion`, `content` | `voice-tone-auditor`, `doc-gap-reviewer` |
| **Ops / Engineering / AI Ops** | `universal`, `champion`, `code` | `bootstrap-context`, `simplify`, `technical-writer` agent |
| **Professional services / Customer success / Legal / People-ops** | `universal`, `champion`, `content` | `doc-gap-reviewer`, `gpt-context-refresher` |
| **Revenue-ops / Sales / Agency** | `universal`, `champion`, `content` | `gpt-context-refresher`, `hallucination-scanner` |
| **Unsure / want everything** | `all` | start with `README.md` above, then pick |

## What this kit solves

These themes recur across every AI Champions cohort I've seen, and each one maps directly to the choices below:

- **"Need to verify every output for accuracy"** → `hallucination-scanner` skill
- **"Overcoming PII and generative AI use case barriers"** → `pii-guard` skill + PII policy template
- **"Custom GPT context caps out at ~50 docs"** → `gpt-context-refresher` skill
- **"How do we maintain evergreen docs?"** → `evergreen-doc-monitor` agent (detects drift) + `technical-writer` agent (executes fixes)
- **"Can I run scheduled tasks on CLI?"** → `schedule-recurring` skill (Claude Code `/loop`, `/schedule`, and Make.com decision guide)
- **"Saves hours per blog/email/case study"** → `voice-tone-auditor` + `doc-gap-reviewer` as a review pair
- **"How are we scanning for hallucinations?"** → `hallucination-scanner` skill with citation verification
- **"Integrating Make.com with Claude"** → `make-bridge` skill (patterns, prompt caching, structured output, error handling)

## Contributing back

If you build a skill or agent worth sharing, open a PR into the matching tier. Each file must include
the frontmatter block shown in `templates/SKILL.template.md` so tooling can index it. See
`CONTRIBUTING.md`.

## Not in scope

- Your organization's specific brand voice. Use `templates/voice-profile.template.md` to make your own.
- Replacements for your org's AI governance policies. This kit assumes you follow them.
- Make.com, Zapier, or NotebookLM wiring — those live in their respective tools. The kit's `make-bridge` skill documents the handoff pattern only.

## License

MIT. See `LICENSE`.
