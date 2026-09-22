#!/usr/bin/env bash
set -uo pipefail

# Reply Open Day setup script for macOS
# Usage:
#   AWS_REGION=eu-central-1 BEDROCK_MODEL_ID='your-model-id' ./setup-mac.sh

AWS_REGION="${AWS_REGION:-eu-central-1}"
BEDROCK_MODEL_ID="${BEDROCK_MODEL_ID:-}"

ok(){ printf '✓ %s\n' "$1"; }
warn(){ printf '! %s\n' "$1"; }
fail(){ printf '✗ %s\n' "$1"; }

if [[ "$(uname -s)" != "Darwin" ]]; then
  fail "This script is for macOS only."
  exit 1
fi

if ! xcode-select -p >/dev/null 2>&1; then
  warn "Apple Command Line Tools are missing."
  xcode-select --install || true
  echo "Complete the installation, then run this script again."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is missing. Installing it..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
    fail "Homebrew installation failed."
    exit 1
  }
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

install_brew(){
  local command_name="$1"
  local package_name="$2"
  if command -v "$command_name" >/dev/null 2>&1; then
    ok "$command_name already installed"
  else
    echo "Installing $package_name..."
    brew install "$package_name" || return 1
    ok "$command_name installed"
  fi
}

install_brew git git || exit 1
install_brew node node || exit 1
install_brew python3 python || exit 1
install_brew aws awscli || exit 1

printf '\nVersions:\n'
git --version
node --version
npm --version
python3 --version
aws --version 2>&1

if [[ -d "/Applications/Kiro.app" || -d "$HOME/Applications/Kiro.app" ]]; then
  ok "Kiro detected"
else
  warn "Kiro was not detected. Install/open Kiro separately."
fi

export AWS_DEFAULT_REGION="$AWS_REGION"
export AWS_REGION="$AWS_REGION"
AWS_PROFILE_NAME="${AWS_PROFILE:-openday-team}"

printf '\nChecking AWS identity (profile: %s)...\n' "$AWS_PROFILE_NAME"
if aws sts get-caller-identity --profile "$AWS_PROFILE_NAME" >/dev/null 2>&1; then
  ok "AWS credentials detected"
else
  warn "No AWS credentials yet under profile '$AWS_PROFILE_NAME' - that's expected if you haven't done Team setup (step 1) yet. Rerun this script after that to confirm."
fi

if [[ -n "$BEDROCK_MODEL_ID" ]]; then
  printf '\nTesting Bedrock model invocation...\n'
  payload_file="$(mktemp)"
  trap 'rm -f "$payload_file"' EXIT
  cat > "$payload_file" <<'JSON'
{"messages":[{"role":"user","content":[{"text":"Reply with exactly: READY"}]}],"inferenceConfig":{"maxTokens":10}}
JSON

  if aws bedrock-runtime converse \
      --model-id "$BEDROCK_MODEL_ID" \
      --region "$AWS_REGION" \
      --profile "$AWS_PROFILE_NAME" \
      --cli-input-json "file://$payload_file" >/tmp/reply-bedrock-result.json; then
    ok "Bedrock invocation works"
  else
    warn "Bedrock invocation failed - check this again after Team setup (step 1) if you haven't done it yet."
  fi
else
  warn "BEDROCK_MODEL_ID was not provided. Bedrock invocation was not tested."
fi

echo
ok "Laptop setup complete"
