# AI Shopping Assistant - Gerçek Zamanlı Nesne Tespiti ile Alışveriş Yardımcısı

Flutter tabanlı mobil uygulama ile market raflarında gerçek zamanlı ürün tanıma ve ürün bilgilerini gösterme sistemi.

## Özellikler

✅ **Gerçek Zamanlı Nesne Tespiti**: Kamera ile canlı görüntü üzerinde sürekli ürün analizi  
✅ **Yerel Model Desteği**: YOLOv8 TFLite modeli ile offline çalışma imkanı  
✅ **Anında Bilgi Gösterimi**: Tespit edilen ürünlerin fiyat ve içerik bilgileri anında ekranda görüntülenir  
✅ **Flutter/React Native**: Flutter framework kullanılarak geliştirilmiştir  
✅ **YOLOv8 Tabanlı**: YOLOv8 veya MobileNet tabanlı çevrimiçi veya yerel model kullanılabilir

## Teknolojiler

- **Frontend**: Flutter
- **AI Model**: YOLOv8 (TFLite formatında)
- **Backend**: FastAPI (opsiyonel, çevrimiçi mod için)
- **Kamera**: Camera plugin
- **ML Inference**: TFLite Flutter

## Kurulum

### Gereksinimler

- Flutter SDK (>=3.0.0)
- Android Studio / Xcode (mobil geliştirme için)
- Python 3.8+ (backend için)

### Adımlar

1. **Projeyi klonlayın**
```bash
git clone <repository-url>
cd ai_shoppinng_assistant
```

2. **Flutter bağımlılıklarını yükleyin**
```bash
flutter pub get
```

3. **Model dosyasını kontrol edin**
   - Model dosyası `assets/models/yolov8n_int8.tflite` konumunda olmalıdır
   - Ürün veritabanı `assets/products.json` dosyasında bulunmaktadır

4. **Uygulamayı çalıştırın**
```bash
flutter run
```

### Backend Kurulumu (Opsiyonel)

Backend sadece çevrimiçi mod için kullanılır. Yerel model kullanımı için gerekli değildir.

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

## Kullanım

1. Uygulamayı açın
2. Kamera izni verin
3. Kamerayı market rafındaki ürünlere doğrultun
4. Ürünler otomatik olarak tespit edilir ve bilgileri anında gösterilir:
   - Ürün adı
   - Fiyat
   - İçerik bilgisi
   - Tespit güven oranı

## Model Eğitimi

Model `datasets/Nescafe/` klasöründe eğitilmiştir. YOLOv8 kullanılarak 3 sınıf için eğitilmiştir:
- Classic
- Gold
- Indo-Cafe

## Proje Yapısı

```
ai_shoppinng_assistant/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── product_detection.dart
│   ├── screens/
│   │   ├── camera_screen.dart      # Gerçek zamanlı kamera ekranı
│   │   └── display_picture_screen.dart
│   ├── services/
│   │   ├── detection_service.dart  # Backend servisi (opsiyonel)
│   │   └── local_detection_service.dart  # Yerel TFLite servisi
│   └── widgets/
├── assets/
│   ├── models/
│   │   └── yolov8n_int8.tflite     # YOLOv8 TFLite modeli
│   └── products.json               # Ürün veritabanı
├── backend/                        # FastAPI backend (opsiyonel)
└── datasets/                       # Eğitim veri seti
```

## Lisans

Bu proje bitirme projesi olarak geliştirilmiştir.
