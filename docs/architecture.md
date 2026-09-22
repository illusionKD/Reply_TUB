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

## What's already deployed vs. what you build

**Already deployed and working** — don't rebuild this: a Lambda function behind an API Gateway HTTP API, with a `/health` endpoint, IAM permissions already granted (including Bedrock access), and a frontend already hosted on Amplify. Opening the deployed URL right now just shows "backend status: live." Proving that AWS plumbing works was done in advance so your 2 hours goes into the actual application, not fighting deployment mechanics.

**Everything else is yours to build**: the ticket endpoints, the Bedrock integration, categorization, and the whole frontend UI. See `functional-requirements.md` for the must-haves.

## Suggested shape

Keep the backend **stateless** — process one ticket at a time, return a result, store nothing. The ticket queue itself (the list, statuses, edits) is a good fit for the **frontend**, in React state persisted to `localStorage`, seeded from `sample-data/sample-tickets.json`. A database (e.g. DynamoDB) is deliberately out of scope — it would add a real persistence layer to debug on top of everything else, for a workshop where the queue only needs to exist within one browser session.

## Deployment

**AWS deployment is required, not optional.** The final demo must use the live deployed URL. Build and test locally while iterating, then push with `backend/update-backend.sh <profile>` and `frontend/deploy-frontend.sh <profile>` — both already work against the pre-provisioned infrastructure, no Docker/SAM/CloudFormation needed on your end.

## Design principles

- Keep responsibilities separated.
- Do not expose AWS credentials in frontend code.
- Validate user input.
- Return useful errors.
- Keep the Bedrock model ID configurable.
- Avoid hardcoding secrets.
- The AI may only ever *recommend* (draft a response, flag urgency, suggest escalation) — a human always takes the final action. See `ai-behavior-guidelines.md`.
