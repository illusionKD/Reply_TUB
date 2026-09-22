import os


class Settings:
    bedrock_model_id: str = os.environ.get(
        "BEDROCK_MODEL_ID", "eu.anthropic.claude-haiku-4-5-20251001-v1:0"
    )
    aws_region: str = os.environ.get("AWS_REGION", "eu-central-1")
    demo_mode: bool = os.environ.get("DEMO_MODE", "false").lower() == "true"
    max_tokens: int = int(os.environ.get("BEDROCK_MAX_TOKENS", "400"))


settings = Settings()
