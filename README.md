

# SiapPA - Sistem Informasi & Pengaduan (Frontend)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

## 📌 Deskripsi Proyek
**SiapPA** adalah aplikasi mobile berbasis Flutter yang dirancang untuk memfasilitasi pelaporan pengaduan masyarakat serta penyediaan informasi melalui artikel. Aplikasi ini mengintegrasikan layanan **Firebase** untuk autentikasi, penyimpanan data, dan penyimpanan media (foto/video pengaduan). 

Proyek ini merupakan bagian *frontend* yang mencakup antarmuka untuk dua peran pengguna utama: **User** (untuk melapor dan melihat riwayat) serta **Admin** (untuk mengelola pengguna, pengaduan, dan artikel).

## ✨ Fitur Utama
- **Autentikasi Pengguna**: Login dan Registrasi menggunakan Firebase Authentication.
- **Sistem Pengaduan Digital**: Pengguna dapat mengirimkan laporan pengaduan lengkap dengan deskripsi, kategori, serta lampiran media (Gambar/Video).
- **Manajemen Media**: Mendukung unggahan foto dan video langsung ke Firebase Storage.
- **Riwayat Pengaduan**: Pengguna dapat memantau status dan riwayat laporan yang telah dikirim.
- **Informasi & Artikel**: Menu berita atau artikel edukasi yang dapat dikelola oleh admin.
- **Dashboard Admin**: Panel kendali untuk admin guna memvalidasi laporan masuk, mengelola data pengguna, serta mempublikasikan artikel baru.
- **Preview Media**: Integrasi pemutar video (Chewie) dan penampil gambar untuk meninjau bukti pengaduan.

## 🛠️ Teknologi yang Digunakan
- **Framework**: [Flutter SDK](https://flutter.dev/).
- **Bahasa Pemrograman**: Dart.
- **State Management**: [Provider](https://pub.dev/packages/provider).
- **Backend Service**: 
  - **Firebase Auth**: Autentikasi.
  - **Cloud Firestore**: Database NoSQL.
  - **Firebase Storage**: Penyimpanan file media.
- **UI & Helper**: 
  - `google_fonts` untuk tipografi.
  - `image_picker` untuk memilih media dari galeri/kamera.
  - `video_player` & `chewie` untuk pemutaran video.
  - `another_flushbar` untuk notifikasi pesan di dalam aplikasi.

## 📋 Prasyarat Instalasi
Sebelum menjalankan aplikasi, pastikan Anda telah menyiapkan:
1. **Flutter SDK** (Versi terbaru sangat disarankan).
2. **Android Studio** atau **VS Code** dengan ekstensi Flutter/Dart.
3. Akun **Firebase** dan buat proyek baru di [Firebase Console](https://console.firebase.google.com/).
4. Unduh file `google-services.json` dan letakkan di direktori `android/app/`.

## 📂 Struktur Proyek
```text
lib/
├── configs/      # Konfigurasi API/Firebase
├── helpers/      # Fungsi pembantu (Dialog, URL Helper)
├── models/       # Data model (Articles, Pengaduans, Users)
├── providers/    # State management logic
├── services/     # API/Firebase service calls
├── utils/        # Konstanta warna, font, dan ukuran
└── views/        # UI Screens (Auth, Admin, User, Splash)

```

## 🚀 Cara Menjalankan Aplikasi

1. **Clone Repositori**:
```bash
git clone [https://github.com/Agussaputr44/siappa-fe.git](https://github.com/Agussaputr44/siappa-fe.git)
cd siappa-fe

```


2. **Instal Dependensi**:
```bash
flutter pub get

```


3. **Setup Firebase**:
Pastikan file `google-services.json` sudah terpasang dengan benar di folder Android.
4. **Jalankan Aplikasi**:
```bash
flutter run

```



## 🤝 Kontribusi

Kami menerima kontribusi untuk pengembangan aplikasi ini:

1. Fork proyek ini.
2. Buat branch fitur baru (`git checkout -b fitur/FiturBaru`).
3. Lakukan Commit perubahan Anda (`git commit -m 'Menambahkan Fitur Baru'`).
4. Push ke branch tersebut (`git push origin fitur/FiturBaru`).
5. Buat Pull Request.

## 📄 Lisensi

Proyek ini dilisensikan di bawah **MIT License**. Anda bebas menggunakan dan memodifikasi kode ini sesuai ketentuan lisensi.

---

**(https://www.google.com/search?q=https://github.com/Agussaputr44)**


