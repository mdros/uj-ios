from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel

app = FastAPI()

# Hardcoded username and password
USERNAME = "testuser"
PASSWORD = "password123"


class LoginRequest(BaseModel):
    username: str
    password: str


@app.post("/login/")
async def login(login_request: LoginRequest):
    if login_request.username == USERNAME and login_request.password == PASSWORD:
        return JSONResponse(content={"message": "Login successful"}, status_code=200)
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")
