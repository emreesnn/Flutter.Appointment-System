# Flutter Appointment System

Bu proje, randevu yönetimi amacıyla Flutter, Laravel ve Strapi teknolojilerini kullanarak oluşturulmuş bir CRUD uygulamasıdır. Uygulama, kullanıcıların randevu oluşturmasını, görüntülemesini, güncellemesini ve iptal etmesini sağlar. Ayrıca kullanıcı kimlik doğrulaması (kayıt & giriş) özelliği sunar.

## ✨ Teknolojiler

- **Flutter**: Mobil uygulama geliştirme.
- **Laravel**: Strapi ile Flutter arasında köprü görevi gören backend API.
- **Strapi**: Randevu CRUD işlemleri için Headless CMS.
- **Riverpod & GoRouter**: Flutter tarafında durum yönetimi ve yönlendirme.

---

## 📦 Proje Yapısı

### 📱 Flutter (mobile)

- `lib/features/appointments`: Randevu modelleri, ekranları ve formları
- `lib/features/auth`: Giriş/kayıt ekranları
- `lib/providers`: `appointmentProvider` ve `authProvider`
- `lib/core/router.dart`: GoRouter rotaları
- `lib/main.dart`: Uygulama giriş noktası

### 🌐 Laravel (bridge)

- `routes/api.php`: Auth ve appointment rotaları
- `app/Http/Controllers`: Laravel üzerinden Strapi ile iletişim kuran controller’lar

### 🚀 Strapi (CMS)

- `/appointments` collection type
- `/auth/local` ve `/auth/local/register` endpoint’leri
- Gerekli izinler `user-permissions` plugin ile tanımlanmalı

---

## 🔐 Kimlik Doğrulama

- Kullanıcılar Laravel üzerinden `/register` ve `/login` endpoint'leriyle Strapi'ye kayıt olur.
- JWT token yapısı uygulanabilir ancak bu projede authentication basit tutulmuştur.
- Kullanıcı giriş durumuna göre giriş/kayıt ekranları gösterilir.

---

## 🗂 Özellikler

- 📆 Takvim görünümünde randevular
- 📝 Randevu oluşturma, düzenleme ve iptal etme
- 👤 Giriş & kayıt işlemleri
- 🎨 Temaya uygun sade ve anlaşılır UI

---

## ⚙️ Kurulum

### 1. Strapi
```bash
cd backend/strapi
npm install
npm run develop
```

### 2. Laravel
```bash
cd backend/laravel
composer install
cp .env.example .env
php artisan key:generate
php artisan serve
```

### 3. Flutter
```bash
cd flutter_appointment_system
flutter pub get
flutter run
Android emülatör için BASE_URL 10.0.2.2 kullanılmalıdır.
```
