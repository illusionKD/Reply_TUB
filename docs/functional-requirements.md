# Functional Requirements

The AWS deployment pipeline (Lambda, API Gateway, Bedrock permissions, Amplify hosting) is already set up and working — that's not your task. Your task is everything below.

## Must haves

### 1. Ticket queue
Show a queue of customer support tickets, seeded from `sample-data/sample-tickets.json`. This can live entirely in the frontend (state + `localStorage`) — no database needed.

### 2. Create
A user can add a new ticket to the queue (message + optional category).

### 3. AI-generated draft
From a selected ticket, a user can trigger AI processing via Amazon Bedrock and get a response draft back.

### 4. Human review, always
Every AI draft displays:
> AI-generated draft. Human review required before sending.

The AI only ever drafts — it never sends anything itself.

### 5. Update
A user can edit the AI's draft, and mark a ticket as approved/sent.

### 6. Archive
A user can archive a ticket (soft delete — a true delete isn't a natural fit for a support-ticket record).

### 7. Validation and error handling
Prevent processing an empty ticket, and show a clear error message if the backend or Bedrock call fails — never expose credentials or internal details, and never silently substitute fake content for a real failure.

### 8. Deployed to AWS
The final demo must use the live deployed URL, not localhost. Use `backend/update-backend.sh` and `frontend/deploy-frontend.sh` to push your changes to the already-provisioned infrastructure — no Docker, SAM, or CloudFormation needed on your end.

## Nice to haves

Only attempt these once all the must-haves work.

**Easier (low risk, good use of spare time):**
- Proper UI design/branding
- A simple status counter ("3 new, 2 resolved, 1 archived") — pure frontend, no backend change
- A "regenerate" button that asks the AI for another draft

**Harder (real AI/backend work — bonus only, not expected of most teams):**
- Auto-categorization (AI infers the category instead of manual selection)
- The AI assessing urgency and flagging which tickets need closer human judgment vs. which are routine
- Tone selection (e.g. more formal / more casual draft)

## Out of scope

- Sending emails.
- Real customer accounts.
- Real order lookups.
- Automatic refunds.
- Production-grade authentication.
- A shared/persistent database — the queue is per-browser by design.
- Complex analytics.
