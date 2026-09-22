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
- `backend/`: FastAPI + Mangum on Lambda. **Only a `/health` endpoint exists right now** — the deployment pipeline is proven, the ticket/AI logic is yours to build. See `backend/README.md`.
- `frontend/`: React + Vite, hosted on AWS Amplify. **Only a placeholder "backend status: live" page exists right now** — the UI is yours to build. See `frontend/README.md`.

## Getting started

A bare skeleton is already deployed to your team's AWS account — just enough to prove the AWS pipeline (Lambda, API Gateway, Bedrock permissions, Amplify hosting) actually works. It doesn't do anything yet. Your job is to build the real application on top of it, guided by `docs/`.

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
4. Ask Kiro to inspect the repository and propose an implementation plan for the must-haves in `docs/functional-requirements.md`.
5. After editing, redeploy with `backend/update-backend.sh myteam` and `frontend/deploy-frontend.sh myteam` — no Docker or SAM needed for either.
6. Build and test the must-haves before attempting any nice-to-haves.

## Important

- Use fictional data only.
- Never commit credentials or secrets.
- Human review is required before any response is sent.
