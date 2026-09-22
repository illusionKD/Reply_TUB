#!/usr/bin/env bash
# Facilitator only. Full SAM build + deploy — requires Docker running locally.
# Usage: ./deploy-backend.sh <aws-cli-profile>
set -euo pipefail
PROFILE="${1:?Usage: ./deploy-backend.sh <aws-cli-profile>}"
cd "$(dirname "$0")"

echo "Building (container build, matches Lambda's Python 3.12 runtime)..."
sam build --use-container

echo "Deploying stack 'openday-backend' with profile $PROFILE..."
sam deploy \
  --profile "$PROFILE" \
  --region eu-central-1 \
  --stack-name openday-backend \
  --capabilities CAPABILITY_NAMED_IAM \
  --resolve-s3 \
  --no-confirm-changeset \
  --no-fail-on-empty-changeset

echo ""
echo "Deployed. Endpoint:"
aws cloudformation describe-stacks --stack-name openday-backend --profile "$PROFILE" --region eu-central-1 \
  --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text
