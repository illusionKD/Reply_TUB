# Frontend - Ticket Assistant UI

React + Vite, hosted on AWS Amplify Hosting.

## For students

You edit files under `src/` — that's the whole surface.

Right now `App.jsx` just checks `/health` and shows "backend status: live" — that proves the deployment pipeline works. You're building the real UI:

- `src/App.jsx` — currently just a status check; replace with the real ticket queue UI
- `src/api.js` — has `checkHealth()`; add your own functions here as you build backend endpoints (e.g. a function to process a ticket)
- Copy `sample-data/sample-tickets.json` (at the repo root) into the frontend to seed your queue, e.g. `src/data/sampleTickets.json`
- Structure your own components under `src/components/` — a queue list, a ticket detail view, a new-ticket form are natural pieces, but organize it however makes sense to your team
- No backend database is needed — the queue (list, statuses, edits) can live entirely in React state + `localStorage`; only the actual AI draft generation needs to call the backend

After editing:
```bash
./deploy-frontend.sh
```
This builds and uploads to Amplify — takes under a minute. (Uses the `openday-team` AWS profile by default; pass a different name as an argument if you set yours up differently.)

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
