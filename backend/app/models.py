from typing import Literal
from pydantic import BaseModel, Field

HUMAN_REVIEW_WARNING = "AI-generated draft. Human review required before sending."

# The AI only ever decides how confident it is (a triage signal for the
# human) — it never sends anything itself. ready_for_review = routine,
# needs_escalation = a human should look closer before drafting is trusted.
Decision = Literal["ready_for_review", "needs_escalation"]
Urgency = Literal["Low", "Medium", "High"]
Source = Literal["bedrock", "demo_mode"]


class TicketRequest(BaseModel):
    ticket: str = Field(..., max_length=4000)
    category: str | None = Field(default=None, max_length=100)


class TicketResponse(BaseModel):
    draft: str
    category: str
    urgency: Urgency
    decision: Decision
    source: Source
    warning: str = HUMAN_REVIEW_WARNING


class ErrorResponse(BaseModel):
    error: str
    detail: str | None = None
