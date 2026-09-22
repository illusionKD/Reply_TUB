"""Canned responses used only when DEMO_MODE=true, or as students' reference
for what a good draft looks like. Never presented as a real AI output —
callers must keep source="demo_mode" on anything returned from here."""

DEMO_DRAFTS: dict[str, str] = {
    "Order status": (
        "Thank you for reaching out about your order. I understand the wait is frustrating. "
        "Could you share your order number so I can look into the current shipping status for you? "
        "Once I have that, I'll follow up with an accurate update."
    ),
    "Returns and exchanges": (
        "Thanks for letting us know you'd like to return this item. To get this started, could you "
        "confirm your order number and roughly when you received the product? I'll then confirm the "
        "return options available for your order."
    ),
    "Damaged products": (
        "I'm sorry to hear the item arrived damaged — that's not the experience we want for you. "
        "Could you send a photo of the damage and your order number? Once I've reviewed it, I'll let "
        "you know the next steps, which may include a replacement."
    ),
    "Billing and refunds": (
        "Thank you for flagging this billing concern. I want to make sure this gets resolved correctly, "
        "so could you confirm your order number and the amount you were charged? I'll verify this against "
        "our records before confirming any refund."
    ),
    "Order changes and complaints": (
        "Thank you for your patience, and I'm sorry for the trouble this has caused. Could you share your "
        "order number so I can check its current status? I want to make sure I give you accurate "
        "information before confirming anything further."
    ),
    "Unknown": (
        "Thanks for contacting us. Could you share a few more details about the issue — such as your order "
        "number and what happened — so I can help you as quickly as possible?"
    ),
}


def get_demo_draft(category: str) -> str:
    return DEMO_DRAFTS.get(category, DEMO_DRAFTS["Unknown"])
