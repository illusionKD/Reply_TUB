#!/usr/bin/env bash
# For students. Redeploys ONLY your edited application code (backend/app/) —
# no Docker, no SAM, no CloudFormation. Dependencies live in a separate Lambda
# Layer that this script never touches.
# Usage: ./update-backend.sh <aws-cli-profile>
set -euo pipefail
PROFILE="${1:?Usage: ./update-backend.sh <aws-cli-profile>}"
cd "$(dirname "$0")/app"

ZIP_PATH="/tmp/openday-backend-update.zip"
rm -f "$ZIP_PATH"
zip -q -r "$ZIP_PATH" . -x '__pycache__/*' -x '*.pyc'

echo "Uploading code to Lambda function 'openday-backend'..."
aws lambda update-function-code \
  --function-name openday-backend \
  --zip-file "fileb://$ZIP_PATH" \
  --profile "$PROFILE" \
  --region eu-central-1 \
  --query 'LastUpdateStatus' --output text

aws lambda wait function-updated --function-name openday-backend --profile "$PROFILE" --region eu-central-1
echo "Done. Backend updated."
