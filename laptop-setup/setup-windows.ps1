# Reply Open Day setup script for Windows PowerShell
# Optional usage:
# $env:AWS_REGION='eu-central-1'; $env:BEDROCK_MODEL_ID='your-model-id'; .\setup-windows.ps1

$ErrorActionPreference = 'Stop'
$AwsRegion = if ($env:AWS_REGION) { $env:AWS_REGION } else { 'eu-central-1' }
$BedrockModelId = $env:BEDROCK_MODEL_ID

function Ok($message) { Write-Host "[OK] $message" }
function Warn($message) { Write-Host "[!]  $message" }
function Fail($message) { Write-Host "[X]  $message" }

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Fail 'winget was not found. Install/update App Installer from Microsoft Store, then rerun this script.'
  exit 1
}

function Ensure-Package($id, $name, $command) {
  if (Get-Command $command -ErrorAction SilentlyContinue) {
    Ok "$name already installed"
    return
  }

  Write-Host "Installing $name..."
  winget install --id $id --exact --accept-source-agreements --accept-package-agreements --silent

  if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
    Warn "$name was installed, but this PowerShell session cannot see it yet."
    Write-Host 'Close PowerShell, open a new window, and rerun the script.'
    exit 2
  }
  Ok "$name installed"
}

Ensure-Package 'Git.Git' 'Git' 'git'
Ensure-Package 'OpenJS.NodeJS.LTS' 'Node.js LTS' 'node'
Ensure-Package 'Python.Python.3.12' 'Python' 'python'
Ensure-Package 'Amazon.AWSCLI' 'AWS CLI' 'aws'

Write-Host "`nVersions:"
git --version
node --version
npm --version
python --version
aws --version

$kiroPaths = @(
  "$env:LOCALAPPDATA\Programs\Kiro\Kiro.exe",
  "$env:ProgramFiles\Kiro\Kiro.exe"
)
if ($kiroPaths | Where-Object { Test-Path $_ }) {
  Ok 'Kiro detected'
} else {
  Warn 'Kiro was not detected. Install/open Kiro separately.'
}

$env:AWS_DEFAULT_REGION = $AwsRegion
$env:AWS_REGION = $AwsRegion

Write-Host "`nChecking AWS identity..."
try {
  $identity = aws sts get-caller-identity --output json
  if ($LASTEXITCODE -ne 0) { throw 'AWS identity check failed' }
  Ok 'AWS credentials detected'
  Write-Host $identity
} catch {
  Warn 'AWS credentials are not configured. Ask the facilitator for the team access method, then rerun this script.'
  exit 3
}

if ([string]::IsNullOrWhiteSpace($BedrockModelId)) {
  Warn 'BEDROCK_MODEL_ID was not provided. Bedrock invocation was not tested.'
} else {
  Write-Host "`nTesting Bedrock model invocation..."
  $payload = '{"messages":[{"role":"user","content":[{"text":"Reply with exactly: READY"}]}],"inferenceConfig":{"maxTokens":10}}'
  $payloadFile = Join-Path $env:TEMP 'reply-open-day-bedrock.json'
  Set-Content -Path $payloadFile -Value $payload -Encoding utf8

  try {
    aws bedrock-runtime converse --model-id $BedrockModelId --region $AwsRegion --cli-input-json "file://$payloadFile"
    if ($LASTEXITCODE -ne 0) { throw 'Bedrock invocation failed' }
    Ok 'Bedrock invocation works'
  } catch {
    Fail 'Bedrock invocation failed. Check model ID, region, and permissions.'
    Remove-Item $payloadFile -Force -ErrorAction SilentlyContinue
    exit 4
  }
  Remove-Item $payloadFile -Force -ErrorAction SilentlyContinue
}

Write-Host ''
Ok 'Laptop setup complete'
