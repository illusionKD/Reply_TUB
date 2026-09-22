from typing import Literal
from pydantic import BaseModel, Field

HUMAN_REVIEW_WARNING = "AI-generated draft. Human review required before sending."


class TicketRequest(BaseModel):
    ticket: str = Field(..., max_length=4000)
    category: str | None = Field(default=None, max_length=100)


class TicketResponse(BaseModel):
    draft: str
    category: str
    source: Literal["bedrock", "demo_mode"]
    warning: str = HUMAN_REVIEW_WARNING


class ErrorResponse(BaseModel):
    error: str
    detail: str | None = None
