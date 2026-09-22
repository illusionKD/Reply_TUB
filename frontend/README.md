# Frontend - Ticket Assistant UI

React + Vite, hosted on AWS Amplify Hosting.

## For students

You edit files under `src/` — that's the whole surface.

- `src/App.jsx` — page layout
- `src/components/TicketForm.jsx` — the input form (categories list lives here)
- `src/components/ResponseDisplay.jsx` — how the draft, category, and source indicator are shown
- `src/api.js` — how the frontend talks to the backend (rarely needs changes)

After editing:
```bash
./deploy-frontend.sh <your-team-profile>
```
This builds and uploads to Amplify — takes under a minute.

## First-time setup

```bash
cp .env.example .env
# edit .env and set VITE_API_URL to your team's backend endpoint (ask a facilitator)
npm install
```

## Local development

```bash
npm run dev
```
Opens a local dev server that talks to your deployed backend (via `VITE_API_URL`).

## For facilitators only

`deploy-frontend.sh` creates the Amplify app on first run (idempotent — safe to rerun). No separate facilitator-only script needed; the same script works before and during the workshop.
