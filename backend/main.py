from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from ultralytics import YOLO
import numpy as np
import cv2

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

model = YOLO("best.pt")

PRODUCT_DB = {
    "bottle": {
        "name": "Su Şişesi",
        "price": 10.0,
        "ingredients": "Doğal kaynak suyu"
    },
    "cup": {
        "name": "Bardak",
        "price": 5.0,
        "ingredients": "Plastik bardak"
    },
    # Buraya kendi ürünlerini ekleyebilirsin:
    # "cola": {...}
}

@app.get("/")
def root():
    return {"message": "Backend çalışıyor!"}

@app.post("/detect")
async def detect_products(image: UploadFile = File(...)):
    image_bytes = await image.read()
    nparr = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    results = model(img)[0]

    detections = []

    for box in results.boxes:
        cls_id = int(box.cls[0])
        label = results.names[cls_id]  # örn: bottle, person...
        conf = float(box.conf[0])

        # 3) Ürünü veri tabanından eşle
        product_info = PRODUCT_DB.get(label)

        if product_info:
            name = product_info["name"]
            price = product_info["price"]
            ingredients = product_info["ingredients"]
        else:
            name = label
            price = 0.0
            ingredients = "Bu nesne için ürün bilgisi yok."

        detections.append(
            {
                "label": label,
                "name": name,
                "price": price,
                "ingredients": ingredients,
                "confidence": conf,
            }
        )

    return {"detections": detections}