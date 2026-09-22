from fastapi import APIRouter, HTTPException

from bedrock_client import BedrockGenerationError, generate_draft
from config import settings
from demo_responses import get_demo_response
from models import TicketRequest, TicketResponse

router = APIRouter()


def _decide(urgency: str) -> str:
    """The AI's triage decision. This NEVER sends anything automatically —
    a human always reviews and clicks send. It only signals how confident
    the AI is, so a human can focus attention on the harder cases first."""
    return "ready_for_review" if urgency == "Low" else "needs_escalation"


@router.get("/health")
def health():
    return {"status": "ok", "demo_mode": settings.demo_mode}


@router.post("/tickets/respond", response_model=TicketResponse)
def respond_to_ticket(payload: TicketRequest):
    ticket = payload.ticket.strip()
    if not ticket:
        raise HTTPException(status_code=400, detail="Ticket text cannot be empty.")

    category = (payload.category or "Unknown").strip() or "Unknown"

    if settings.demo_mode:
        urgency, draft = get_demo_response(category)
        source = "demo_mode"
    else:
        try:
            urgency, draft = generate_draft(ticket, category)
        except BedrockGenerationError as exc:
            raise HTTPException(
                status_code=502,
                detail=f"AI generation failed. Please try again, or ask a facilitator. ({exc})",
            ) from exc
        source = "bedrock"

    return TicketResponse(
        draft=draft,
        category=category,
        urgency=urgency,
        decision=_decide(urgency),
        source=source,
    )
