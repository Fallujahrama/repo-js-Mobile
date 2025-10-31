# 📸 Tugas 9 - Camera App dengan Material Design

Aplikasi Flutter untuk mengakses kamera, mengambil foto, dan menyimpan ke Gallery dengan implementasi Material Design 3.

## ✨ Fitur Lengkap

### ✅ Point Tugas yang Diimplementasikan:

1. **Material Design dari pub.dev** 
   - Material Design 3 (useMaterial3: true)
   - ColorScheme, AppBar, FAB, Buttons, SnackBar, Dialog

2. **Preview Kamera & Ambil Gambar**
   - Real-time camera preview
   - Capture foto dengan FloatingActionButton

3. **Switch Kamera Depan & Belakang**
   - Toggle antara kamera rear dan front
   - Visual indicator kamera aktif

4. **Tampilkan Path File di Layar/SnackBar**
   - Dialog untuk menampilkan path file (selectable text)
   - SnackBar menampilkan path setelah save

5. **Simpan ke Direktori Lokal**
   - Simpan ke Gallery/Pictures menggunakan `image_gallery_saver`
   - Path provider untuk akses file system

### 🎁 Fitur Bonus:
- ✅ Retake foto dengan preview fresh
- ✅ Material ripple effect pada tombol
- ✅ Loading indicator saat initialize
- ✅ Error handling lengkap
- ✅ Web support (conditional rendering)

---

## 🚀 Cara Menjalankan

### 1. Install Dependencies
```bash
cd tugas9
flutter pub get
```

### 2. Run di Chrome (Web)
```bash
flutter run -d chrome
```

### 3. Run di Android
```bash
flutter run
```

### 4. Build APK
```bash
flutter build apk --release
```

---

## 📦 Dependencies

```yaml
dependencies:
  camera: ^0.11.3                    # Camera plugin
  image_gallery_saver: ^2.0.3       # Save foto ke Gallery
  path_provider: ^2.1.1              # Akses direktori sistem
```

---

## 📱 Cara Menggunakan Aplikasi

### 1. Camera Preview Screen
- Tekan icon **flip** (kiri) → Switch kamera depan/belakang
- Tekan tombol **biru besar** (tengah) → Ambil foto
- Icon kanan menunjukkan kamera aktif

### 2. Photo Preview Screen
- Tekan **"Lihat Path File"** → Lihat lokasi file foto (bisa di-copy)
- Tekan **"Retake"** → Kembali ke kamera untuk foto ulang
- Tekan **"Save"** → Simpan foto ke Gallery + lihat path di SnackBar

---

## 📂 Lokasi Penyimpanan Foto

### Android:
```
/storage/emulated/0/Pictures/camera_1730356789123.jpg
```
Foto akan muncul di aplikasi **Gallery** HP.

### Web:
```
Browser Cache (temporary)
```
Foto tidak tersimpan permanen di Web.

---

## 🎨 Material Design Components

- ✅ Material Design 3 Theme
- ✅ AppBar dengan title centered
- ✅ FloatingActionButton.large
- ✅ Material InkWell (ripple effect)
- ✅ ElevatedButton dengan custom style
- ✅ SnackBar dengan floating behavior
- ✅ AlertDialog dengan rounded corners
- ✅ SelectableText untuk copy path

---

## 📸 Screenshots

### Camera Preview
![Camera Preview](https://via.placeholder.com/300x500?text=Camera+Preview)

### Photo Preview
![Photo Preview](https://via.placeholder.com/300x500?text=Photo+Preview)

### Path Dialog
![Path Dialog](https://via.placeholder.com/300x300?text=Path+Dialog)

---

## 📄 Dokumentasi Lengkap

Lihat [DOKUMENTASI_TUGAS9.md](DOKUMENTASI_TUGAS9.md) untuk penjelasan detail implementasi setiap point tugas.

---

## 👨‍💻 Pembuat

**Nama:** Fallujah Ramadi  
**Mata Kuliah:** Pemrograman Mobile  
**Tugas:** Praktikum 9 - Camera Plugin  
**Tanggal:** 31 Oktober 2025

---

## 📝 Catatan

- Aplikasi sudah ditest di **Web (Chrome)** dan siap untuk **Android**
- Permission kamera dan storage sudah ditambahkan di AndroidManifest.xml
- Untuk iOS, tambahkan permission di Info.plist jika diperlukan

---

## 🐛 Troubleshooting

### Problem: Camera not working
**Solution:** Pastikan permission kamera sudah diberi di Settings HP

### Problem: Save to Gallery failed
**Solution:** Pastikan permission storage sudah diberi

### Problem: Preview freeze setelah Retake
**Solution:** Sudah diperbaiki dengan key-based rebuild

---

## 📚 Referensi

- [Camera Plugin](https://pub.dev/packages/camera)
- [Image Gallery Saver](https://pub.dev/packages/image_gallery_saver)
- [Path Provider](https://pub.dev/packages/path_provider)
- [Material Design 3](https://m3.material.io/)
