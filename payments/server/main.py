from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

# In-memory storage for payments
payments = []


class CardData(BaseModel):
    card_number: str
    expiry_date: str
    cvv: str


@app.post("/validate-card")
def validate_card(card_data: CardData):
    card_number = card_data.card_number
    expiry_date = card_data.expiry_date
    cvv = card_data.cvv

    print(card_data)

    if not card_number or not expiry_date or not cvv:
        raise HTTPException(status_code=400, detail="Invalid card data")

    # Simple validation logic (for demonstration purposes)
    if len(card_number) == 16 and len(cvv) == 3:
        return {"status_code": "200"}
    else:
        raise HTTPException(status_code=400, detail="Invalid card data")
