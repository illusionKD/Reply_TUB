# Definition of Done

## Must haves (see functional-requirements.md for detail)

- [ ] Deployed to AWS and reachable via the live endpoint — not localhost.
- [ ] Ticket queue visible, seeded from the sample tickets.
- [ ] A user can add a new ticket.
- [ ] A user can select a ticket and get a real AI-generated draft back.
- [ ] The human-review warning is shown on every draft.
- [ ] A user can edit the draft and mark it approved/sent.
- [ ] A user can archive a ticket.
- [ ] Empty input is handled; a Bedrock failure shows a clear error, not a crash or silently-substituted content.
- [ ] At least one missing-information ticket is tested.
- [ ] At least one difficult/frustrated customer ticket is tested.
- [ ] The team can explain one important design decision.

## Nice to haves

Only after every must-have above works:

**Easier:** proper UI design, a status counter, a "regenerate" button.
**Harder (bonus):** auto-categorization, AI urgency/escalation triage, tone selection.
