# Suggested Architecture

## Target flow

```text
Frontend
   |
   v
Backend API
   |
   v
Amazon Bedrock
   |
   v
Response draft
```

## Possible AWS implementation

```text
Frontend
   |
   v
API Gateway
   |
   v
AWS Lambda
   |
   v
Amazon Bedrock
```

## Implementation guidance

Start with the simplest architecture that can produce a working result.

**AWS deployment is required, not optional.** The final demo must call a deployed API Gateway endpoint backed by a Lambda function invoking Bedrock — not a process running only on localhost.

The team may still:
- Build and test locally first while iterating quickly.
- Use a local backend temporarily during development.

But before the demo, the same flow must be redeployed behind API Gateway + Lambda, and the demo must use that live endpoint.

## Where ticket state lives

The backend is intentionally **stateless** — it processes one ticket at a time and stores nothing. The ticket queue itself (the list, statuses, edits) lives entirely in the **frontend**, in React state persisted to `localStorage`, seeded from `sample-data/sample-tickets.json`. There is no database. This was a deliberate simplicity choice: a shared database (e.g. DynamoDB) would add a real persistence layer for a beginner team to debug on top of everything else, for a workshop where the queue only needs to exist within one browser session.

## Design principles

- Keep responsibilities separated.
- Do not expose AWS credentials in frontend code.
- Validate user input.
- Return useful errors.
- Keep the Bedrock model ID configurable.
- Avoid hardcoding secrets.
- The AI may only ever *recommend* (draft a response, flag urgency, suggest escalation) — a human always takes the final action. See `ai-behavior-guidelines.md`.
