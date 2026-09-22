# Backend - Ticket Assistant API

FastAPI + Mangum on AWS Lambda, behind API Gateway, calling Amazon Bedrock (Claude Haiku 4.5).

## For students

You edit files under `app/` — that's the whole surface. Nothing else in this folder needs to change.

Only `/health` exists right now — that proves the deployment pipeline works. You're building everything else:

- `app/main.py` — FastAPI app, CORS, Lambda handler (rarely needs changes)
- `app/routes.py` — add your ticket-processing endpoint(s) here. Keep it stateless: take a ticket's text/category, call Bedrock, return a result. The ticket queue itself belongs in the frontend, not here.
- `app/config.py` — already has `BEDROCK_MODEL_ID` and `DEMO_MODE` settings wired up and ready to use
- `app/models.py` — define your request/response shapes here
- Add whatever other files make sense (a prompts module, a Bedrock client module) — keep it organized, but the structure is yours to decide

A couple of hard requirements from `docs/ai-behavior-guidelines.md` and `functional-requirements.md`, regardless of how you structure it: every AI draft must carry the human-review warning, and a real Bedrock failure must show a clear error — never silently swapped for fake content.

After editing, redeploy your change with:
```bash
./update-backend.sh
```
This only uploads your code — no Docker, no SAM, no CloudFormation. Uses the `openday-team` AWS profile by default (see root README "Team setup"). Don't add new pip dependencies; the ones already provided (fastapi, mangum, boto3, pydantic) cover everything this app needs. If you think you need another one, ask a facilitator.

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

**Configuration** (environment variables on the Lambda, already wired up in `app/config.py` and `template.yaml`):
- `BEDROCK_MODEL_ID` — defaults to `eu.anthropic.claude-haiku-4-5-20251001-v1:0`
- `DEMO_MODE` — reserved as a **facilitator-controlled emergency switch** (e.g. if Bedrock becomes unavailable account-wide mid-workshop). Off by default. Students building their ticket endpoint should read `settings.demo_mode` and, if true, skip the real Bedrock call — but this is a facilitator lever, not something students need to build UI around.

  ```bash
  # facilitator only, emergency use
  aws lambda update-function-configuration --function-name openday-backend \
    --environment "Variables={BEDROCK_MODEL_ID=eu.anthropic.claude-haiku-4-5-20251001-v1:0,DEMO_MODE=true}" \
    --profile <profile> --region eu-central-1
  ```

**Important design rule, whatever you build**: on a real Bedrock failure, return a clear error — never silently substitute fake content for a real failure. A team should never mistake a broken Bedrock call for a real AI answer.

No credentials or secrets are hardcoded anywhere — the Lambda's AWS permissions come from its IAM execution role, not from keys in code.
