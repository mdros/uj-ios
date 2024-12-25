from fastapi import FastAPI
from starlette.middleware.cors import CORSMiddleware

app = FastAPI()

categories = [{"id": 1, "name": "Electronics"}, {"id": 2, "name": "Furniture"}]
products = [
    {"id": 1, "name": "Laptop", "category_id": 1},
    {"id": 2, "name": "Smartphone", "category_id": 1},
    {"id": 3, "name": "Desk Chair", "category_id": 2},
    {"id": 4, "name": "Coffee Table", "category_id": 2},
    {"id": 5, "name": "Tea Cup", "category_id": None},
]

origins = [
    "http://localhost",
    "http://localhost:8080",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/products")
async def get_products():
    return {"items": products, "total": len(products)}


@app.get("/categories")
async def get_categories():
    return {"items": categories, "total": len(categories)}
