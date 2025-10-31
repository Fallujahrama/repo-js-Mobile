# 📸 Dokumentasi Tugas 9 - Camera App dengan Material Design

## ✅ Implementasi Tugas Praktikum

### **Point 1: Material Design dari pub.dev** ✅
Implementasi Material Design 3 dengan tema yang konsisten:

```dart
theme: ThemeData(
  primarySwatch: Colors.blue,
  useMaterial3: true,  // Material Design 3
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
)
```

**Fitur Material Design yang digunakan:**
- ✅ Material Design 3 (useMaterial3: true)
- ✅ ColorScheme dengan seed color
- ✅ Floating Action Button dengan elevation
- ✅ Material InkWell dengan ripple effect
- ✅ Rounded corners pada semua tombol
- ✅ Consistent spacing dan padding
- ✅ SnackBar dengan floating behavior
- ✅ AlertDialog dengan rounded corners

---

### **Point 2: Preview Kamera dan Ambil Gambar** ✅

**Fitur yang diimplementasikan:**
- ✅ Preview kamera real-time dengan `CameraPreview`
- ✅ Tombol capture dengan `FloatingActionButton.large`
- ✅ Foto disimpan ke variabel `XFile? capturedImage`
- ✅ Auto-switch ke screen preview setelah ambil foto

**Kode:**
```dart
// Ambil foto
Future<void> takePicture() async {
  final image = await controller.takePicture();
  setState(() {
    capturedImage = image;
  });
}
```

---

### **Point 3: Berpindah Antara Kamera Depan dan Belakang** ✅

**Fitur yang diimplementasikan:**
- ✅ Tombol switch camera dengan icon flip
- ✅ Toggle antara kamera belakang (index 0) dan depan (index 1)
- ✅ Auto re-initialize controller setelah switch
- ✅ Indicator visual kamera aktif (icon rear/front)

**Kode:**
```dart
Future<void> switchCamera() async {
  selectedCameraIndex = (selectedCameraIndex + 1) % _cameras.length;
  await controller.dispose();
  await initializeCamera(selectedCameraIndex);
}
```

**UI Indicator:**
```dart
Icon(
  selectedCameraIndex == 0 
    ? Icons.camera_rear   // Kamera belakang
    : Icons.camera_front, // Kamera depan
)
```

---

### **Point 4: Tampilkan Path File Foto di Layar atau SnackBar** ✅

#### **A. SnackBar dengan Path (saat Save)**
Menampilkan path file setelah foto berhasil disimpan:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Column(
      children: [
        Text('Foto berhasil disimpan!'),
        Text('Path: ${result['filePath']}'),
      ],
    ),
  ),
);
```

**Output SnackBar:**
```
✅ Foto berhasil disimpan!
Path: /storage/emulated/0/Pictures/camera_1730356789123.jpg
```

#### **B. Dialog dengan Path (Tombol "Lihat Path File")**
Menampilkan dialog lengkap dengan path file yang bisa di-copy:

```dart
void showPathDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Path File Foto'),
      content: SelectableText(imagePath),
    ),
  );
}
```

**Fitur:**
- ✅ Dialog dengan Material Design
- ✅ Path file bisa di-select dan di-copy
- ✅ UI yang clean dan informatif

---

### **Point 5: Simpan Foto ke Direktori Lokal (path_provider)** ✅

#### **Menggunakan `image_gallery_saver`**
Plugin ini otomatis menyimpan foto ke **Gallery/Pictures** (direktori lokal Android):

```dart
final result = await ImageGallerySaver.saveImage(
  bytes,
  quality: 100,
  name: 'camera_${DateTime.now().millisecondsSinceEpoch}',
);
```

**Lokasi Penyimpanan:**
```
Android: /storage/emulated/0/Pictures/
iOS: Photos Library
```

**Path provider sudah included** untuk akses direktori sistem.

---

## 🎨 **Komponen Material Design yang Digunakan**

### **1. AppBar**
```dart
AppBar(
  title: Text('Tugas 9 - Camera App'),
  centerTitle: true,
)
```

### **2. FloatingActionButton**
```dart
FloatingActionButton.large(
  onPressed: takePicture,
  child: Icon(Icons.camera_alt, size: 36),
  elevation: 4,
)
```

### **3. Material InkWell (Ripple Effect)**
```dart
Material(
  color: Colors.blue.shade100,
  borderRadius: BorderRadius.circular(50),
  child: InkWell(
    onTap: switchCamera,
    child: Icon(...),
  ),
)
```

### **4. ElevatedButton dengan Custom Style**
```dart
ElevatedButton.icon(
  onPressed: saveToGallery,
  icon: Icon(Icons.save),
  label: Text('Save'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: EdgeInsets.symmetric(vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
)
```

### **5. SnackBar dengan Floating Behavior**
```dart
SnackBar(
  content: Row(
    children: [
      Icon(Icons.check_circle),
      Text('Success'),
    ],
  ),
  behavior: SnackBarBehavior.floating,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
)
```

### **6. AlertDialog**
```dart
AlertDialog(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  title: Row(
    children: [
      Icon(Icons.folder_open),
      Text('Path File'),
    ],
  ),
)
```

---

## 📱 **Fitur Lengkap Aplikasi**

### **1. Camera Preview Screen**
- ✅ Real-time camera preview
- ✅ Tombol switch camera (kiri)
- ✅ Tombol capture foto (tengah)
- ✅ Indicator kamera aktif (kanan)

### **2. Photo Preview Screen**
- ✅ Tampilan foto fullscreen
- ✅ Tombol "Lihat Path File" → Tampilkan dialog dengan path
- ✅ Tombol "Retake" → Kembali ke camera preview
- ✅ Tombol "Save" → Simpan ke Gallery + tampilkan path di SnackBar

---

## 🚀 **Cara Menjalankan**

### **1. Web (Chrome)**
```bash
cd /Users/fallujahramadi/dart/pertemuan9/tugas9
flutter run -d chrome
```

### **2. Android**
```bash
flutter run
```

### **3. Build APK**
```bash
flutter build apk --release
```

---

## 📂 **Struktur Project**

```
tugas9/
├── lib/
│   └── main.dart           # Kode lengkap dengan Material Design
├── android/
│   └── app/
│       └── src/
│           └── main/
│               └── AndroidManifest.xml  # Permission kamera & storage
├── pubspec.yaml            # Dependencies
└── DOKUMENTASI_TUGAS9.md   # Dokumentasi ini
```

---

## 📦 **Dependencies yang Digunakan**

```yaml
dependencies:
  camera: ^0.11.3                    # Camera plugin
  image_gallery_saver: ^2.0.3       # Save ke Gallery
  path_provider: ^2.1.1              # Akses direktori sistem
```

---

## ✨ **Screenshot Flow Aplikasi**

### **1. Camera Preview**
```
┌─────────────────────────┐
│   Tugas 9 - Camera App  │
├─────────────────────────┤
│                         │
│   [Camera Preview]      │
│                         │
├─────────────────────────┤
│  [Flip]  [Capture]  [📷]│
└─────────────────────────┘
```

### **2. Photo Preview**
```
┌─────────────────────────┐
│      Preview Foto       │
├─────────────────────────┤
│                         │
│   [Captured Image]      │
│                         │
├─────────────────────────┤
│   [Lihat Path File]     │
│  [Retake]    [Save]     │
└─────────────────────────┘
```

### **3. Path Dialog**
```
┌─────────────────────────┐
│  📁 Path File Foto      │
├─────────────────────────┤
│ Lokasi file foto:       │
│                         │
│ /data/.../cache/xxx.jpg │
│                         │
│           [Tutup]       │
└─────────────────────────┘
```

### **4. Success SnackBar**
```
╔═════════════════════════╗
║ ✅ Foto berhasil disimpan!║
║ Path: /storage/.../xxx.jpg║
╚═════════════════════════╝
```

---

## 🎯 **Kesimpulan Implementasi Tugas**

| No | Point Tugas | Status | Keterangan |
|----|-------------|--------|------------|
| 1 | Material Design dari pub.dev | ✅ | Material Design 3 dengan theme lengkap |
| 2 | Preview & Ambil Gambar | ✅ | Preview real-time + capture foto |
| 3 | Switch Kamera Depan/Belakang | ✅ | Toggle dengan indicator visual |
| 4 | Tampilkan Path di Layar/SnackBar | ✅ | Dialog + SnackBar dengan path lengkap |
| 5 | Simpan ke Direktori Lokal | ✅ | Gallery/Pictures dengan path_provider |

---

## 💡 **Fitur Bonus**

1. ✅ **Indicator Kamera Aktif** - Icon rear/front camera
2. ✅ **Material Ripple Effect** - InkWell pada tombol
3. ✅ **Selectable Path Text** - Bisa copy path dari dialog
4. ✅ **Loading Indicator** - Saat kamera initialize
5. ✅ **Error Handling** - Try-catch pada semua operasi
6. ✅ **Web Support** - Conditional rendering untuk Web
7. ✅ **Fresh Preview** - Key-based rebuild untuk smooth UX

---

**Dibuat oleh:** Fallujah Ramadi  
**Tanggal:** 31 Oktober 2025  
**Mata Kuliah:** Pemrograman Mobile  
**Tugas:** Praktikum 9 - Camera Plugin
