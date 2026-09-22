from fastapi import APIRouter, HTTPException

from bedrock_client import BedrockGenerationError, generate_draft
from config import settings
from demo_responses import get_demo_draft
from models import TicketRequest, TicketResponse

router = APIRouter()


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
        return TicketResponse(draft=get_demo_draft(category), category=category, source="demo_mode")

    try:
        draft = generate_draft(ticket, category)
    except BedrockGenerationError as exc:
        raise HTTPException(
            status_code=502,
            detail=f"AI generation failed. Please try again, or ask a facilitator. ({exc})",
        ) from exc

    return TicketResponse(draft=draft, category=category, source="bedrock")
