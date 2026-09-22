# Functional Requirements

## Minimum viable product

### FR-01: Ticket queue

The application shows a queue of customer support tickets, seeded from `sample-data/sample-tickets.json`. This is client-side state (per browser), not a shared database.

### FR-02: Create

A user can add a new ticket to the queue (message + optional category).

### FR-03: Process with AI

From a selected ticket, a user can trigger AI processing via Amazon Bedrock. The AI returns: a response draft, an urgency level (Low/Medium/High), and a triage decision (`ready_for_review` or `needs_escalation`).

### FR-04: AI decision, never AI sending

The AI's decision only changes how a ticket is *prioritized* for a human (routine vs. needs closer judgment). It never sends anything and never bypasses human review — see `ai-behavior-guidelines.md`.

### FR-05: Update

A user can edit the AI's draft, and can change a ticket's status (e.g. mark "Approved & sent" after reviewing).

### FR-06: Archive

A user can archive a ticket (soft delete — a true delete isn't a natural fit for a support-ticket record).

### FR-07: Human review warning

The application displays, on every AI-generated draft:

> AI-generated draft. Human review required before sending.

### FR-08: Validation

The application prevents processing an empty ticket and shows a helpful message.

### FR-09: Loading state

The application shows that AI processing is in progress.

### FR-10: Error handling

If the backend or model invocation fails, the application shows a clear error — never a silently substituted demo response, and never exposed credentials or internal details.

## Backend expectations

The backend is intentionally stateless — it does not store tickets. It should:
- Receive one ticket's text + category.
- Validate the request.
- Build a prompt using the business context and behavior guidelines.
- Invoke Amazon Bedrock, parse out the urgency and draft.
- Derive the triage decision from urgency.
- Return a structured response to the frontend.

The ticket queue, its statuses, and edits all live in the frontend (React state + `localStorage`) — there is no database. This keeps the backend simple and avoids giving a beginner team a data-persistence layer to debug on top of everything else.

**Deployment requirement**: the backend must run on AWS (API Gateway + Lambda) for the final demo, not only on localhost. Local runs are fine during development.

## Out of scope

- Sending emails.
- Real customer accounts.
- Real order lookups.
- Automatic refunds.
- Production-grade authentication.
- A shared/persistent database — the queue is per-browser by design.
- Complex analytics.
