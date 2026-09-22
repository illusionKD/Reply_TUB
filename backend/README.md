# Backend - Ticket Assistant API

FastAPI + Mangum on AWS Lambda, behind API Gateway, calling Amazon Bedrock (Claude Haiku 4.5).

## For students

You edit files under `app/` — that's the whole surface. Nothing else in this folder needs to change.

- `app/main.py` — FastAPI app, CORS, Lambda handler (rarely needs changes)
- `app/routes.py` — API endpoints (`/health`, `/tickets/respond`). This is stateless — it processes one ticket and returns a draft + urgency + triage decision. The ticket queue itself lives in the frontend, not here.
- `app/prompts.py` — the system prompt and how ticket text becomes a Bedrock request, including the `URGENCY:`/`DRAFT:` output format. **Most of your prompt-engineering work happens here.**
- `app/bedrock_client.py` — the actual Bedrock call and output parsing
- `app/demo_responses.py` — canned responses used only when `DEMO_MODE=true`
- `app/models.py` — request/response shapes

After editing, redeploy your change with:
```bash
./update-backend.sh <your-team-profile>
```
This only uploads your code — no Docker, no SAM, no CloudFormation. Don't add new pip dependencies; the ones already provided (fastapi, mangum, boto3, pydantic) cover everything this app needs. If you think you need another one, ask a facilitator.

## Local testing (before deploying)

```bash
python3.12 -m venv venv && source venv/bin/activate
pip install -r requirements-dev.txt
python3 -m pytest tests/ -v
```
Tests run with `DEMO_MODE=true` by default, so they never call real Bedrock.

## For facilitators only

`deploy-backend.sh` does the full SAM build + deploy (creates the Lambda, its execution role, the Lambda Layer holding dependencies, and the API Gateway). Requires Docker running locally.

```bash
./deploy-backend.sh <aws-cli-profile>
```

Run this once per account before the workshop. After that, students only ever use `update-backend.sh`.

**Configuration** (environment variables on the Lambda, set via `template.yaml` parameters):
- `BEDROCK_MODEL_ID` — defaults to `eu.anthropic.claude-haiku-4-5-20251001-v1:0`
- `DEMO_MODE` — a **facilitator-controlled manual switch**, not an automatic fallback. It is off (`"false"`) by default and stays off for the whole workshop unless a facilitator deliberately flips it — e.g. as an emergency measure if Bedrock becomes unavailable account-wide. Students should never need to touch this.

  ```bash
  # facilitator only, emergency use
  aws lambda update-function-configuration --function-name openday-backend \
    --environment "Variables={BEDROCK_MODEL_ID=eu.anthropic.claude-haiku-4-5-20251001-v1:0,DEMO_MODE=true}" \
    --profile <profile> --region eu-central-1
  ```

**Important — what happens on a real Bedrock failure (`DEMO_MODE=false`, the normal state)**: the API returns a clear `502` error (`"AI generation failed. Please try again, or ask a facilitator."`), shown as an error message in the frontend. It does **not** silently substitute a demo response — a team should never mistake a broken Bedrock call for a real AI answer. `demo_mode` responses are always explicitly tagged `"source": "demo_mode"` in the API response and shown with a visibly different badge in the UI, so the two states can never be confused with each other.

No credentials or secrets are hardcoded anywhere — the Lambda's AWS permissions come from its IAM execution role, not from keys in code.
