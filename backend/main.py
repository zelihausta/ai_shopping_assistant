from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from ultralytics import YOLO
import numpy as np
import cv2
import json
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

model = YOLO("best.pt")

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(BASE_DIR, "products.json"), "r", encoding="utf-8") as f:
    PRODUCT_DB = json.load(f)

@app.get("/")
def root():
    return {"message": "Backend çalışıyor!"}

@app.post("/detect")
async def detect_products(image: UploadFile = File(...)):
    image_bytes = await image.read()
    nparr = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    results = model(img)[0]

    products = []
    added_labels = set()

    for box in results.boxes:
        cls_id = int(box.cls[0])
        label = results.names[cls_id]
        conf = float(box.conf[0])


        if conf < 0.5:
            continue
        if label in added_labels:
            continue

        product_info = PRODUCT_DB.get(label)

        if product_info:
            name = product_info["name"]
            price = product_info["price"]
            ingredients = product_info["ingredients"]
        else:
            name = label
            price = 0.0
            ingredients = "Bu ürün için bilgi bulunamadı."

        products.append(
            {
                "label": label,
                "name": name,
                "price": price,
                "ingredients": ingredients,
                "confidence": round(conf, 2),
            }
        )

        added_labels.add(label)

    return {
        "count": len(products),
        "products": products
    }
