#!/usr/bin/env bash
# Builds the React/Vite app and deploys it to AWS Amplify Hosting (manual zip deploy).
# Safe for both the facilitator's first deploy and students' later redeploys -
# creates the Amplify app/branch if they don't exist yet, reuses them otherwise.
# Usage: ./deploy-frontend.sh <aws-cli-profile>
set -euo pipefail
PROFILE="${1:?Usage: ./deploy-frontend.sh <aws-cli-profile>}"
REGION="eu-central-1"
APP_NAME="openday-frontend"
BRANCH="main"

cd "$(dirname "$0")"

if [ ! -f .env ]; then
  echo "ERROR: .env not found. Copy .env.example to .env and set VITE_API_URL to your backend's endpoint first."
  exit 1
fi

echo "Installing dependencies..."
npm install --no-fund --no-audit

echo "Building..."
npm run build

APP_ID=$(aws amplify list-apps --profile "$PROFILE" --region "$REGION" \
  --query "apps[?name=='$APP_NAME'].appId | [0]" --output text)

if [ "$APP_ID" == "None" ] || [ -z "$APP_ID" ]; then
  echo "Creating Amplify app..."
  APP_ID=$(aws amplify create-app --name "$APP_NAME" --profile "$PROFILE" --region "$REGION" \
    --query 'app.appId' --output text)
fi

if ! aws amplify get-branch --app-id "$APP_ID" --branch-name "$BRANCH" --profile "$PROFILE" --region "$REGION" >/dev/null 2>&1; then
  echo "Creating branch..."
  aws amplify create-branch --app-id "$APP_ID" --branch-name "$BRANCH" --profile "$PROFILE" --region "$REGION" >/dev/null
fi

ZIP_PATH="/tmp/openday-frontend.zip"
rm -f "$ZIP_PATH"
(cd dist && zip -q -r "$ZIP_PATH" .)

DEPLOYMENT_JSON=$(aws amplify create-deployment --app-id "$APP_ID" --branch-name "$BRANCH" --profile "$PROFILE" --region "$REGION")
UPLOAD_URL=$(echo "$DEPLOYMENT_JSON" | python3 -c "import json,sys; print(json.load(sys.stdin)['zipUploadUrl'])")
JOB_ID=$(echo "$DEPLOYMENT_JSON" | python3 -c "import json,sys; print(json.load(sys.stdin)['jobId'])")

echo "Uploading build..."
curl -s -T "$ZIP_PATH" "$UPLOAD_URL" -o /dev/null

aws amplify start-deployment --app-id "$APP_ID" --branch-name "$BRANCH" --job-id "$JOB_ID" \
  --profile "$PROFILE" --region "$REGION" >/dev/null

echo "Waiting for deployment to finish..."
for i in $(seq 1 20); do
  STATUS=$(aws amplify get-job --app-id "$APP_ID" --branch-name "$BRANCH" --job-id "$JOB_ID" \
    --profile "$PROFILE" --region "$REGION" --query 'job.summary.status' --output text)
  echo "  status: $STATUS"
  if [ "$STATUS" == "SUCCEED" ] || [ "$STATUS" == "FAILED" ]; then break; fi
  sleep 5
done

echo ""
echo "Site URL: https://$BRANCH.$APP_ID.amplifyapp.com"
