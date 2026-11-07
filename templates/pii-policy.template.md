# PII / data handling policy — [Your team]

Adapt this to your team and confirm with Legal / GRC before publishing.
`skills/champion-specific/pii-guard.md` will reference this file when scanning content.

## Tiers

### Tier 0 — Public
Safe to paste into any AI tool, public channel, or external document.

- Published marketing copy
- Public documentation
- Press releases after publication

### Tier 1 — Internal, low-sensitivity
Safe for enterprise AI tools under your company's contract (e.g., enterprise Claude or ChatGPT Enterprise),
not for free/consumer accounts or external tools.

- Internal SOPs without customer names
- Aggregated metrics without identifying any individual
- Product roadmap items not under NDA

### Tier 2 — Restricted, requires redaction
Must be redacted before entering any AI tool. If redaction isn't possible, don't use AI.

- Customer names, company names, contact info
- Deal values, contract terms, pricing specific to a deal
- Support tickets with customer identifiers
- Recruitment candidate data

### Tier 3 — Prohibited
Never enters any AI tool, full stop. Requires human handling only.

- Employee PII (SSN, compensation, DOB, medical)
- Regulated customer data (HIPAA, PCI, GDPR special categories)
- Legal privileged communications
- MNPI / material non-public information
- Signed contracts pre-publication

## What counts as PII here

- Full name + any identifier (email, employer, title)
- Email addresses (even if "looks public")
- Phone numbers
- Physical addresses
- Government IDs of any kind
- Payment info
- Access credentials or tokens (even test/staging)

## Redaction patterns

Replace inline before pasting:

| Pattern | Replace with |
|---|---|
| John Smith (ACME Corp) | [CUSTOMER_NAME] ([COMPANY]) |
| jane@example.com | [EMAIL] |
| $125,000 ARR deal | [DEAL_VALUE] deal |
| Order #A-12345 | Order #[ORDER_ID] |

## If in doubt

1. Don't paste it.
2. Ask in #ai-champions or #legal-ai.
3. Route through an approved tool (enterprise Claude/ChatGPT, not a personal account).
