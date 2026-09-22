import re

import boto3
from botocore.exceptions import BotoCoreError, ClientError

from config import settings
from prompts import SYSTEM_PROMPT, build_user_message

_client = None

_URGENCY_RE = re.compile(r"URGENCY:\s*(Low|Medium|High)", re.IGNORECASE)
_DRAFT_SPLIT_RE = re.compile(r"DRAFT:\s*", re.IGNORECASE)


def _get_client():
    global _client
    if _client is None:
        _client = boto3.client("bedrock-runtime", region_name=settings.aws_region)
    return _client


class BedrockGenerationError(Exception):
    """Raised when a Bedrock call fails. Callers surface this as a clear
    error to the user — no automatic retry, no silent fallback."""


def _parse_output(text: str) -> tuple[str, str]:
    """Parses the model's URGENCY:/DRAFT: formatted output. Falls back to
    safe defaults if the model doesn't follow the format exactly, so a
    formatting slip never breaks the request."""
    urgency_match = _URGENCY_RE.search(text)
    urgency = urgency_match.group(1).capitalize() if urgency_match else "Medium"

    parts = _DRAFT_SPLIT_RE.split(text, maxsplit=1)
    draft = parts[1].strip() if len(parts) == 2 else text.strip()

    return urgency, draft


def generate_draft(ticket: str, category: str) -> tuple[str, str]:
    """Returns (urgency, draft)."""
    try:
        response = _get_client().converse(
            modelId=settings.bedrock_model_id,
            system=[{"text": SYSTEM_PROMPT}],
            messages=[
                {"role": "user", "content": [{"text": build_user_message(ticket, category)}]}
            ],
            inferenceConfig={"maxTokens": settings.max_tokens},
        )
        text = response["output"]["message"]["content"][0]["text"]
        return _parse_output(text)
    except (ClientError, BotoCoreError, KeyError, IndexError) as exc:
        raise BedrockGenerationError(str(exc)) from exc
