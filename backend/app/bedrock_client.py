import boto3
from botocore.exceptions import BotoCoreError, ClientError

from config import settings
from prompts import SYSTEM_PROMPT, build_user_message

_client = None


def _get_client():
    global _client
    if _client is None:
        _client = boto3.client("bedrock-runtime", region_name=settings.aws_region)
    return _client


class BedrockGenerationError(Exception):
    """Raised when a Bedrock call fails. Callers surface this as a clear
    error to the user — no automatic retry, no silent fallback."""


def generate_draft(ticket: str, category: str) -> str:
    try:
        response = _get_client().converse(
            modelId=settings.bedrock_model_id,
            system=[{"text": SYSTEM_PROMPT}],
            messages=[
                {"role": "user", "content": [{"text": build_user_message(ticket, category)}]}
            ],
            inferenceConfig={"maxTokens": settings.max_tokens},
        )
        return response["output"]["message"]["content"][0]["text"]
    except (ClientError, BotoCoreError, KeyError, IndexError) as exc:
        raise BedrockGenerationError(str(exc)) from exc
