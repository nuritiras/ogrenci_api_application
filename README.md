
# 🏫 Okul Yönetim Sistemi (Flutter & Django)

Bu proje, bir Computer Science eğitim materyali olarak geliştirilmiştir. Django tabanlı bir API ile Flutter mobil uygulamasının nasıl haberleştiğini gösterir.

## 🚀 Özellikler
- **Django REST Framework** ile tam CRUD desteği.
- **CORS** yapılandırması ile güvenli erişim.
- **Flutter FutureBuilder** ile asenkron veri listeleme.
- **Clean Architecture** prensiplerine uygun katmanlı yapı.

## 🛠 Kurulum

### 1. Backend (Django)
```bash
cd backend
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver