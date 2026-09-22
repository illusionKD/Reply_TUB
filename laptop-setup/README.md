# Reply Open Day laptop setup

Students only need to bring a Windows or macOS laptop, charger, and browser. Run the relevant script during the workshop.

## macOS

```bash
chmod +x setup-mac.sh
./setup-mac.sh
```

Optional Bedrock test:

```bash
AWS_REGION=eu-central-1 BEDROCK_MODEL_ID='YOUR_MODEL_ID' ./setup-mac.sh
```

## Windows

Open PowerShell in this folder:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup-windows.ps1
```

Optional Bedrock test:

```powershell
$env:AWS_REGION='eu-central-1'
$env:BEDROCK_MODEL_ID='YOUR_MODEL_ID'
.\setup-windows.ps1
```

## Important facilitator notes

- Test both scripts on a clean Mac and Windows laptop before the event.
- Kiro is detected but not automatically installed.
- Students must receive AWS access through your approved temporary-credential or SSO process.
- Never place AWS access keys or secrets in this repository.
- Keep a preconfigured spare laptop and a fallback Bedrock demo available.
