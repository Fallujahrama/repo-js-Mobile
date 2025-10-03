# Instruksi Penggunaan Cover Art

## 📋 Cara Menambahkan Gambar Cover Art:

1. **Siapkan File Gambar Cover:**
   - Gunakan gambar "a beautiful blur" yang sudah disediakan atau gambar lain yang Anda pilih
   - Format: JPG
   - Ukuran yang direkomendasikan: 500 x 500 pixels

2. **Rename File:**
   - Rename file gambar menjadi `cover.jpg`

3. **Letakkan File di Folder Yang Tepat:**
   ```
   /Users/fallujahramadi/prakflutter/tugasproject/assets/images/cover.jpg
   ```

4. **Refresh Aplikasi:**
   - Jalankan `flutter clean` diikuti dengan `flutter pub get` untuk memastikan asset diload dengan benar
   - Run aplikasi dengan `flutter run`

## 🚀 Fitur Yang Telah Diimplementasikan:

### 🏠 **Halaman Utama (HOME)**
- Desain clean & modern dengan gradient background
- Cover art lagu yang besar dan menonjol
- Judul lagu & nama artist dengan font yang lebih besar
- Tombol PLAY dengan efek elevation yang menarik
- Tombol VIEW LYRICS untuk melihat lirik saja

### 📝 **Halaman Lirik (LYRICS)**
- Tampilan khusus lirik dengan format yang rapi
- Tombol PLAY NOW untuk langsung ke music player

### 🎵 **Music Player**
- Player dengan cover art di bagian atas
- Progress bar dengan timestamp
- Kontrol player: rewind 10s, play/pause, forward 10s
- Tampilan lirik scrollable di bawah player

## 💡 Tips Editing:
Jika Anda ingin mengubah gambar nanti, cukup ganti file `cover.jpg` dengan file baru (tetap dengan nama yang sama) dan restart aplikasi.