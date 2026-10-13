# EcoVillage - Panduan Setup Firebase

## Kondisi Sekarang
Aplikasi berjalan dengan **dummy data** (tidak perlu internet).
Login tersimpan di **SharedPreferences**.

---

## Cara Aktifkan Firebase (Nanti)

### 1. Buat project di Firebase Console
- Buka https://console.firebase.google.com
- Klik "Add project" → beri nama misal `ecovillage-kkn`
- Aktifkan **Firestore Database** dan **Authentication**

### 2. Tambahkan Android App
- Di Firebase Console → Project Settings → Add App → Android
- Package name: `com.example.ecovillage` (sesuaikan `applicationId` di `android/app/build.gradle`)
- Download `google-services.json` → letakkan di `android/app/`

### 3. Update `android/build.gradle`
```gradle
// Tambahkan di bagian dependencies
classpath 'com.google.gms:google-services:4.4.0'
```

### 4. Update `android/app/build.gradle`
```gradle
// Tambahkan di baris paling bawah
apply plugin: 'com.google.gms.google-services'
```

### 5. Aktifkan kode Firebase di aplikasi

Di `lib/main.dart`, uncomment:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Di main():
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

Di `lib/services/auth_service.dart`, uncomment blok Firebase dan hapus blok dummy.

Di `lib/services/data_service.dart`, uncomment baris Firestore dan hapus baris dummy.

### 6. Seed data Firestore
Upload struktur koleksi berikut:
- **Collection: `jadwal`** → dokumen sesuai `JadwalModel`
- **Collection: `laporan`** → dokumen sesuai `LaporanModel`
- **Collection: `statistik`** → dokumen `desa` dengan field: `totalWarga`, `totalPetugas`, dll
- **Collection: `users`** → dibuat otomatis saat user register

### 7. Aturan Firestore (rules)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /jadwal/{doc} {
      allow read: if request.auth != null;
      allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'petugas';
    }
    match /laporan/{doc} {
      allow read, write: if request.auth != null;
    }
    match /statistik/{doc} {
      allow read: if request.auth != null;
      allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'petugas';
    }
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

---

## Akun Demo (Mode Dummy)
| Role    | Email              | Password |
|---------|-------------------|----------|
| Warga   | warga@desa.com    | 123456   |
| Petugas | petugas@desa.com  | 123456   |

---

## Struktur Proyek
```
lib/
├── main.dart
├── models/
│   ├── user_model.dart
│   ├── jadwal_model.dart
│   └── laporan_model.dart
├── services/
│   ├── auth_service.dart      ← Login + SharedPreferences
│   └── data_service.dart      ← Data (dummy → Firebase)
├── screens/
│   ├── splash_screen.dart     ← Auto-login check
│   ├── auth/login_screen.dart
│   ├── home/home_screen.dart  ← Dashboard + bottom nav
│   ├── jadwal/jadwal_screen.dart
│   ├── lapor/lapor_screen.dart
│   └── edukasi/edukasi_screen.dart
└── utils/
    └── app_constants.dart     ← Warna, ukuran, data statis
```
