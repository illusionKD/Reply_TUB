"""Canned responses used only when DEMO_MODE=true, or as students' reference
for what a good draft looks like. Never presented as a real AI output —
callers must keep source="demo_mode" on anything returned from here."""

DEMO_DATA: dict[str, dict[str, str]] = {
    "Order status": {
        "urgency": "Low",
        "draft": (
            "Thank you for reaching out about your order. I understand the wait is frustrating. "
            "Could you share your order number so I can look into the current shipping status for you? "
            "Once I have that, I'll follow up with an accurate update."
        ),
    },
    "Returns and exchanges": {
        "urgency": "Low",
        "draft": (
            "Thanks for letting us know you'd like to return this item. To get this started, could you "
            "confirm your order number and roughly when you received the product? I'll then confirm the "
            "return options available for your order."
        ),
    },
    "Damaged products": {
        "urgency": "Medium",
        "draft": (
            "I'm sorry to hear the item arrived damaged — that's not the experience we want for you. "
            "Could you send a photo of the damage and your order number? Once I've reviewed it, I'll let "
            "you know the next steps, which may include a replacement."
        ),
    },
    "Billing and refunds": {
        "urgency": "Medium",
        "draft": (
            "Thank you for flagging this billing concern. I want to make sure this gets resolved correctly, "
            "so could you confirm your order number and the amount you were charged? I'll verify this against "
            "our records before confirming any refund."
        ),
    },
    "Order changes and complaints": {
        "urgency": "High",
        "draft": (
            "Thank you for your patience, and I'm sorry for the trouble this has caused. Could you share your "
            "order number so I can check its current status? I want to make sure I give you accurate "
            "information before confirming anything further."
        ),
    },
    "Unknown": {
        "urgency": "Medium",
        "draft": (
            "Thanks for contacting us. Could you share a few more details about the issue — such as your order "
            "number and what happened — so I can help you as quickly as possible?"
        ),
    },
}


def get_demo_response(category: str) -> tuple[str, str]:
    """Returns (urgency, draft)."""
    entry = DEMO_DATA.get(category, DEMO_DATA["Unknown"])
    return entry["urgency"], entry["draft"]
