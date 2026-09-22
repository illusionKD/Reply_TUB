import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "app"))

os.environ.setdefault("DEMO_MODE", "true")  # local tests never call real Bedrock

from fastapi.testclient import TestClient  # noqa: E402
from main import app  # noqa: E402 - flat import, matches how Lambda loads this module

client = TestClient(app)


def test_health():
    r = client.get("/health")
    assert r.status_code == 200
    assert r.json()["status"] == "ok"


def test_respond_empty_ticket_rejected():
    r = client.post("/tickets/respond", json={"ticket": "   "})
    assert r.status_code == 400


def test_respond_demo_mode_returns_source_indicator():
    r = client.post("/tickets/respond", json={"ticket": "Where is my order?", "category": "Order status"})
    assert r.status_code == 200
    body = r.json()
    assert body["source"] == "demo_mode"
    assert "Human review" in body["warning"] or "human review" in body["warning"].lower()
    assert len(body["draft"]) > 0


def test_respond_unknown_category_falls_back():
    r = client.post("/tickets/respond", json={"ticket": "Something is wrong."})
    assert r.status_code == 200
    assert r.json()["category"] == "Unknown"
