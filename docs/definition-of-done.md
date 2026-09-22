# Definition of Done

A team can demonstrate the following:

- [ ] The application is deployed to AWS (API Gateway + Lambda) and reachable via a live endpoint — not running only on localhost.
- [ ] A ticket queue is visible, seeded from the sample tickets.
- [ ] A user can select a ticket and trigger AI processing.
- [ ] The application invokes Amazon Bedrock and shows urgency + the AI's triage decision (ready for review / needs escalation).
- [ ] A response draft is displayed and is editable.
- [ ] A user can mark a ticket as approved/sent, and can archive a ticket.
- [ ] A user can add a new ticket to the queue.
- [ ] The human-review warning is visible on every AI draft.
- [ ] Empty input is handled.
- [ ] At least one missing-information ticket is tested.
- [ ] At least one difficult/frustrated customer ticket is tested.
- [ ] The team can explain one important design decision.

## Stretch goals

Only attempt these after the MVP works:

- Smarter/more consistent auto-classification of category.
- Regenerate a draft with a different tone.
- A dashboard/count of ready-for-review vs. needs-escalation tickets.
- Side-by-side comparison of two different prompt strategies.
- Voice input for dictating a ticket.
- Response quality checklist shown next to the draft.
