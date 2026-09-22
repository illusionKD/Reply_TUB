# Reply Open Day: AI Customer Support Assistant

Build an AI-powered assistant that helps customer support employees draft responses to customer tickets.

## Goal

Create a working prototype using Kiro, AWS, and Amazon Bedrock.

The application should:
- Accept a customer support ticket.
- Accept or identify a ticket category.
- Generate a response draft.
- Display a human-review warning.
- Handle missing information safely.

## Repository structure

- `docs/business-context.md`: Company and business context
- `docs/ai-behavior-guidelines.md`: Rules the AI must follow
- `docs/functional-requirements.md`: Minimum product requirements
- `docs/architecture.md`: Suggested technical architecture (AWS deployment required)
- `docs/definition-of-done.md`: Demonstration criteria
- `docs/mob-programming.md`: Team working method
- `docs/tool-primer.md`: Plain-English AWS/Kiro glossary — no prior experience needed
- `sample-data/sample-tickets.json`: Fictional test tickets
- `prompts/initial-kiro-prompt.md`: Initial Kiro prompt
- `backend/`: FastAPI + Mangum on Lambda, calling Bedrock — **already deployed and working**. Students edit `backend/app/` only. See `backend/README.md`.
- `frontend/`: React + Vite, hosted on AWS Amplify — **already deployed and working**. Students edit `frontend/src/` only. See `frontend/README.md`.

## Getting started

A working skeleton is already deployed to your team's AWS account (health check, demo-mode fallback, and a real Bedrock call all confirmed working before the event). Your job is to extend it, not build it from zero.

### 1. Team setup (do this first, once)

Your facilitator will give you: an **AWS Access Key ID + Secret Access Key** for your team's account, and your team's **backend API endpoint** (a URL like `https://xxxxx.execute-api.eu-central-1.amazonaws.com`).

```bash
# Register your team's AWS credentials as a named profile
aws configure --profile myteam
#   AWS Access Key ID: <from your facilitator>
#   AWS Secret Access Key: <from your facilitator>
#   Default region: eu-central-1
#   Default output format: json

# Confirm it works — should print YOUR team's AWS account ID
aws sts get-caller-identity --profile myteam

# Point the frontend at your team's backend
cd frontend
cp .env.example .env
# edit .env: set VITE_API_URL to the endpoint your facilitator gave you
npm install
```

Use `myteam` (or whatever profile name you chose) as the `<profile>` argument to every deploy script below.

### 2. Build

1. Read the files in `docs/`.
2. Open the repository in Kiro.
3. Use the initial Kiro prompt.
4. Ask Kiro to inspect the repository (including the already-working `backend/` and `frontend/`) and propose an implementation plan for the real functionality: better categorization, better prompts, UI polish.
5. After editing, redeploy with `backend/update-backend.sh myteam` and `frontend/deploy-frontend.sh myteam` — no Docker or SAM needed for either.
6. Build and test the minimum viable product before adding stretch goals.

## Important

- Use fictional data only.
- Never commit credentials or secrets.
- Human review is required before any response is sent.
