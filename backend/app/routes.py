from fastapi import APIRouter

from config import settings

router = APIRouter()


@router.get("/health")
def health():
    """Proof-of-life endpoint — confirms the deployment pipeline (Lambda,
    API Gateway, IAM permissions) works. Everything else (ticket endpoints,
    Bedrock integration, categorization) is what you build."""
    return {"status": "ok", "demo_mode": settings.demo_mode}
