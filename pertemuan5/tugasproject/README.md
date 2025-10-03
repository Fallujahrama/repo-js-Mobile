# Project Lyric

Aplikasi pemutar musik dengan tampilan lirik yang disinkronisasi, dibuat dengan Flutter.

## Deskripsi Proyek

Project Lyric adalah aplikasi pemutar musik yang menampilkan lirik yang tersinkronisasi dengan lagu, mirip dengan fitur yang ada di Spotify. Aplikasi ini memungkinkan pengguna untuk melihat lirik yang disorot sesuai dengan posisi lagu yang sedang diputar.

## Fitur Utama

- Pemutar musik dengan kontrol pemutaran (play, pause, seek forward/backward)
- Tampilan lirik yang tersinkronisasi dengan musik
- Sorotan lirik secara otomatis saat musik diputar
- Pengguliran (auto-scrolling) pintar yang mengikuti lirik yang sedang diputar
- Tampilan lirik statis terpisah
- Desain UI yang menarik dengan gradien warna

## Struktur Proyek

Proyek ini terdiri dari tiga file utama:

1. **main.dart** - Entry point aplikasi dan implementasi HomePage
2. **music_player_page.dart** - Implementasi pemutar musik dengan lirik tersinkronisasi
3. **lyrics_page.dart** - Halaman untuk menampilkan lirik tanpa fitur pemutaran

### Penjelasan File Utama

#### main.dart

File ini berisi:
- Entry point aplikasi (`main()`)
- Konfigurasi tema aplikasi
- Implementasi `HomePage` dengan:
  - Latar belakang gradient
  - Tampilan cover art
  - Tombol navigasi ke halaman pemutar musik dan lirik statis

```dart
import 'package:flutter/material.dart';
import 'lyrics_page.dart';
import 'music_player_page.dart';

void main() {
  runApp(const LyricsApp());
}

class LyricsApp extends StatelessWidget {
  const LyricsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lyrics App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF03045e),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF03045e),
          secondary: Color(0xFF0077b6),
        ),
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF90e0ef),
              Color(0xFFcaf0f8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              
              // Cover Art
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      spreadRadius: 2,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/cover.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback jika gambar tidak ditemukan
                      return Container(
                        height: 300,
                        width: 300,
                        color: Colors.deepPurple.shade300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.music_note,
                                size: 100,
                                color: Colors.white,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'a beautiful blur',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Tombol navigasi
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MusicPlayerPage()),
                  );
                },
                icon: Icon(Icons.play_circle_filled, size: 36),
                label: Text('PLAY NOW'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF03045e),
                  foregroundColor: Colors.white,
                ),
              ),
              
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LyricsOnlyPage()),
                  );
                },
                child: Text('VIEW LYRICS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Penjelasan Fungsi dalam main.dart:**

- `main()`: Fungsi entry point yang menjalankan aplikasi Flutter.
- `LyricsApp`: Widget StatelessWidget utama yang mengkonfigurasi tema aplikasi dan menentukan halaman awal.
- `HomePage`: Widget yang menampilkan halaman utama aplikasi dengan:
  - Gradient background dengan warna biru muda yang menarik
  - Cover art lagu dalam container dengan efek shadow
  - Error handler untuk menampilkan fallback jika gambar tidak ditemukan
  - Tombol "PLAY NOW" untuk navigasi ke halaman pemutar musik
  - Tombol "VIEW LYRICS" untuk navigasi ke halaman lirik statis

#### music_player_page.dart

File ini berisi:
- Model data `LyricLine` untuk menyimpan waktu dan teks lirik
- Kelas `MusicPlayerPage` yang mengimplementasikan:
  - Pemutar audio menggunakan paket `audioplayers`
  - Sistem pelacakan waktu lagu
  - Algoritma pencocokan lirik berdasarkan posisi waktu lagu
  - Sistem pengguliran otomatis (auto-scroll) yang pintar
  - Sorotan lirik yang sedang diputar
  - UI pemutar musik dengan kontrol pemutaran

```dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// Model untuk menyimpan data lirik dengan informasi waktu
class LyricLine {
  final String text;
  final Duration startTime;
  final Duration endTime;
  
  const LyricLine({
    required this.text,
    required this.startTime,
    required this.endTime,
  });
}

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  bool isPlaying = false;
  late AudioPlayer audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  int currentLyricIndex = -1;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    audioPlayer = AudioPlayer();
    
    // Mendengarkan perubahan durasi lagu
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });
    
    // Mendengarkan perubahan posisi pemutaran lagu
    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
          // Update lirik aktif berdasarkan posisi
          _updateCurrentLyricLine();
        });
      }
    });
    
    // Mendengarkan status pemutaran
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
  }
  
  // Fungsi untuk mencari lirik yang aktif berdasarkan posisi waktu
  void _updateCurrentLyricLine() {
    int newIndex = -1;
    
    // Iterasi mundur untuk menemukan lirik yang sesuai dengan posisi waktu
    for (int i = 0; i < syncedLyrics.length; i++) {
      LyricLine line = syncedLyrics[i];
      if (position >= line.startTime && position <= line.endTime) {
        newIndex = i;
        break;
      }
      
      // Jika berada di antara lirik
      if (position >= line.startTime && 
          (i == syncedLyrics.length - 1 || position < syncedLyrics[i + 1].startTime)) {
        newIndex = i;
        break;
      }
    }
    
    // Perbarui UI dan scroll hanya jika indeks lirik berubah
    if (currentLyricIndex != newIndex && newIndex >= 0) {
      setState(() {
        currentLyricIndex = newIndex;
      });
      
      // Auto-scroll ke lirik yang aktif
      _scrollToCurrentLine();
    }
  }
  
  // Helper method untuk memeriksa apakah lirik terlihat di layar
  bool _isLyricLineVisible(int index) {
    if (!_scrollController.hasClients) return false;
    
    // Hitung perkiraan posisi lirik
    double lineHeight = 30.0;
    double lineTop = index * lineHeight;
    double lineBottom = lineTop + lineHeight;
    
    // Dapatkan batas viewport scroll saat ini
    double scrollTop = _scrollController.offset;
    double scrollBottom = scrollTop + MediaQuery.of(context).size.height * 0.4;
    
    // Lirik terlihat jika posisinya dalam viewport
    return (lineTop >= scrollTop && lineTop <= scrollBottom) ||
           (lineBottom >= scrollTop && lineBottom <= scrollBottom);
  }
  
  // Fungsi untuk menggulir ke lirik aktif dengan smart scrolling
  void _scrollToActiveLyric(int activeLyricIndex) {
    if (activeLyricIndex >= 0 && 
        activeLyricIndex < syncedLyrics.length &&
        _scrollController.hasClients) {
        
      // Cek apakah lirik terlihat di layar
      bool isLineVisible = _isLyricLineVisible(activeLyricIndex);
      
      // Jika di bagian lirik akhir, kurangi intensitas scroll
      double scrollOffset;
      if (activeLyricIndex >= 24) {
        // Untuk lirik akhir, scroll minimal jika tidak terlihat
        if (!isLineVisible) {
          // Scroll sedikit di bawah posisi sekarang
          scrollOffset = _scrollController.offset + 30.0;
          
          // Pastikan tidak melewati batas maksimal scroll
          double maxScroll = _scrollController.position.maxScrollExtent;
          if (scrollOffset > maxScroll) {
            scrollOffset = maxScroll;
          }
          
          _scrollController.animateTo(
            scrollOffset,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        }
        return;
      }
      
      // Untuk lirik awal dan tengah, scroll ke tengah viewport
      double viewportHeight = MediaQuery.of(context).size.height * 0.4;
      scrollOffset = (activeLyricIndex * 30.0) - (viewportHeight / 2) + 15.0;
      
      // Pastikan tidak negatif
      scrollOffset = scrollOffset < 0 ? 0 : scrollOffset;
      
      // Pastikan tidak melebihi batas maksimal
      double maxScroll = _scrollController.position.maxScrollExtent;
      if (scrollOffset > maxScroll) {
        scrollOffset = maxScroll;
      }
      
      // Animasi scroll halus
      _scrollController.animateTo(
        scrollOffset,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
```

**Penjelasan Fungsi dalam music_player_page.dart:**

- `LyricLine`: Model data untuk menyimpan teks lirik beserta timestamp awal dan akhir.
- `initState()`: Inisialisasi audio player dan mendaftarkan listener untuk berbagai event pemutaran.
- `_updateCurrentLyricLine()`: Fungsi untuk menentukan lirik yang aktif berdasarkan posisi waktu pemutaran.
- `_isLyricLineVisible()`: Fungsi helper untuk mengecek apakah lirik tertentu sudah terlihat di layar.
- `_scrollToActiveLyric()`: Fungsi smart scrolling yang:
  - Mengecek visibilitas lirik aktif sebelum melakukan scroll
  - Menerapkan strategi scrolling berbeda untuk lirik di akhir lagu (scroll minimal)
  - Mengatur posisi scroll agar lirik aktif berada di tengah viewport
  - Menerapkan animasi scroll halus dengan durasi yang sesuai

#### lyrics_page.dart

File ini berisi:
- Implementasi `LyricsOnlyPage` untuk menampilkan lirik dalam format statis
- Formating lirik yang konsisten dengan halaman pemutar musik
- Tombol navigasi untuk kembali ke halaman pemutar musik

```dart
import 'package:flutter/material.dart';
import 'music_player_page.dart';

class LyricsOnlyPage extends StatelessWidget {
  const LyricsOnlyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'XXL Lyrics', 
          style: TextStyle(
            color: Colors.white, 
            fontStyle: FontStyle.italic, 
            fontFamily: 'Roboto', 
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF03045e),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 10,
        shadowColor: Color(0xFF90e0ef),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header dengan judul lagu dan artis
            Column(
              children: [
                Text(
                  'XXL',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03045e),
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'by LANY',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
            
            // Lirik statis
            Column(
              children: [
                "All my favorite songs are from 2018",
                "We flew around the world with our small-town dreams",
                // Lirik lainnya...
              ].map((line) => Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: line.isEmpty ? 4 : 6),
                child: Center(
                  child: Text(
                    line,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )).toList(),
            ),
            
            SizedBox(height: 40),
            
            // Tombol Play untuk navigasi ke halaman pemutar musik
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MusicPlayerPage()),
                );
              },
              icon: Icon(Icons.play_arrow, size: 30),
              label: Text(
                'PLAY NOW',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF03045e),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Penjelasan Fungsi dalam lyrics_page.dart:**

- `LyricsOnlyPage`: Widget StatelessWidget yang menampilkan lirik lagu dalam format statis:
  - Header dengan judul lagu dan nama artis
  - Teks lirik lengkap dengan format yang konsisten (ukuran font, spasi, alignment)
  - Tombol "PLAY NOW" yang mengarahkan pengguna ke halaman pemutar musik
- Lirik ditampilkan dengan menggunakan `map()` untuk mengkonversi daftar string menjadi daftar widget
- Penggunaan `SingleChildScrollView` untuk memungkinkan scrolling saat lirik tidak muat di layar

## Algoritma Utama

### 1. Sinkronisasi Lirik dengan Audio

Algoritma ini mencocokkan lirik dengan posisi waktu lagu:

```dart
// Di dalam fungsi _updateCurrentLyricLine()
void _updateCurrentLyricLine() {
  int newIndex = -1;
  
  // Iterasi untuk menemukan lirik yang sesuai dengan posisi waktu saat ini
  for (int i = 0; i < syncedLyrics.length; i++) {
    LyricLine line = syncedLyrics[i];
    // Jika posisi berada di antara waktu mulai dan akhir lirik
    if (position >= line.startTime && position <= line.endTime) {
      newIndex = i;
      break;
    }
    
    // Jika berada di antara lirik ini dan lirik berikutnya
    if (position >= line.startTime && 
        (i == syncedLyrics.length - 1 || position < syncedLyrics[i + 1].startTime)) {
      newIndex = i;
      break;
    }
  }
  
  // Perbarui UI dan scroll hanya jika indeks lirik berubah
  if (currentLyricIndex != newIndex && newIndex >= 0) {
    setState(() {
      currentLyricIndex = newIndex;
    });
    
    // Auto-scroll ke lirik yang aktif
    _scrollToCurrentLine();
  }
}
```

**Penjelasan Algoritma Sinkronisasi:**
- Algoritma ini dipanggil setiap kali posisi pemutaran berubah
- Mencari lirik yang timeStamp-nya cocok dengan posisi pemutaran saat ini
- Jika lirik aktif berubah, UI diperbarui dan fungsi auto-scroll dipanggil
- Menggunakan dua kondisi untuk menentukan lirik aktif:
  1. Posisi tepat berada di antara waktu mulai dan akhir lirik
  2. Posisi berada setelah waktu mulai lirik ini dan sebelum lirik berikutnya

### 2. Pengguliran Otomatis Pintar

Algoritma ini mengelola pengguliran otomatis dengan memeriksa visibilitas lirik dan menerapkan strategi scrolling berbeda untuk bagian awal/tengah dan akhir lagu:

```dart
void _scrollToCurrentLine() {
  if (currentLyricIndex >= 0 && _scrollController.hasClients) {
    // Cek apakah line yang sedang aktif sudah visible di layar
    bool isLineVisible = _isLyricLineVisible(currentLyricIndex);
    
    // Jika sudah di bagian lirik akhir (index >= 24), kurangi intensitas scroll
    double scrollOffset;
    if (currentLyricIndex >= 24) {
      // Untuk lirik akhir, scroll minimal saja jika tidak terlihat
      if (!isLineVisible) {
        // Scroll hanya sedikit di bawah posisi sekarang
        scrollOffset = _scrollController.offset + 30.0;
        
        // Pastikan tidak melewati batas maksimal scroll
        double maxScroll = _scrollController.position.maxScrollExtent;
        if (scrollOffset > maxScroll) {
          scrollOffset = maxScroll;
        }
        
        // Smooth scroll animation dengan durasi lebih pendek
        _scrollController.animateTo(
          scrollOffset,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
      return;
    }
    
    // Untuk lirik di bagian awal dan tengah, scroll ke tengah viewport
    double viewportHeight = MediaQuery.of(context).size.height * 0.4;
    scrollOffset = (currentLyricIndex * 30.0) - (viewportHeight / 2) + 15.0;
    
    // Pastikan nilai tidak negatif
    scrollOffset = scrollOffset < 0 ? 0 : scrollOffset;
    
    // Pastikan tidak melebihi batas maksimal
    double maxScroll = _scrollController.position.maxScrollExtent;
    if (scrollOffset > maxScroll) {
      scrollOffset = maxScroll;
    }
    
    // Smooth scroll animation
    _scrollController.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
```

**Penjelasan Algoritma Pengguliran Pintar:**
- Mengecek visibilitas lirik sebelum melakukan scroll (optimalisasi performa)
- Menerapkan strategi scrolling berbeda berdasarkan posisi di daftar lirik:
  - Untuk lirik di bagian akhir (index >= 24): scrolling minimal untuk menghindari over-scrolling
  - Untuk lirik di bagian awal/tengah: scrolling untuk menempatkan lirik di tengah viewport
- Mencegah scrolling melewati batas atas (negatif) atau bawah (maxScrollExtent)
- Menggunakan animasi scroll dengan durasi yang berbeda untuk pengalaman yang halus

### 3. Pemeriksaan Visibilitas Lirik

Metode helper untuk memeriksa apakah lirik terlihat di layar:

```dart
bool _isLyricLineVisible(int index) {
  if (!_scrollController.hasClients) return false;
  
  // Hitung perkiraan posisi lirik
  double lineHeight = 30.0;
  double lineTop = index * lineHeight;
  double lineBottom = lineTop + lineHeight;
  
  // Dapatkan batas viewport scroll saat ini
  double scrollTop = _scrollController.offset;
  double scrollBottom = scrollTop + MediaQuery.of(context).size.height * 0.4;
  
  // Lirik terlihat jika posisinya dalam viewport
  return (lineTop >= scrollTop && lineTop <= scrollBottom) ||
         (lineBottom >= scrollTop && lineBottom <= scrollBottom);
}
```

**Penjelasan Fungsi Pemeriksaan Visibilitas:**
- Menghitung posisi relatif lirik berdasarkan tinggi setiap baris (lineHeight)
- Mendapatkan batas atas (scrollTop) dan bawah (scrollBottom) viewport saat ini
- Mengembalikan true jika bagian atas atau bawah lirik berada dalam viewport
- Fungsi ini penting untuk optimasi karena mencegah scrolling jika lirik sudah terlihat

## Format Data Lirik

Lirik diformat sebagai daftar objek `LyricLine` yang berisi waktu awal, waktu akhir, dan teks:

```dart
final List<LyricLine> syncedLyrics = [
  LyricLine(
    text: "All my favorite songs are from 2018", 
    startTime: Duration(seconds: 9), 
    endTime: Duration(seconds: 11)
  ),
  LyricLine(
    text: "We flew around the world with our small-town dreams", 
    startTime: Duration(seconds: 12), 
    endTime: Duration(seconds: 15)
  ),
  LyricLine(
    text: "You're a superstar and you wear it so well", 
    startTime: Duration(seconds: 15), 
    endTime: Duration(seconds: 18)
  ),
  // Lirik lainnya...
];
```

**Penjelasan Format Data Lirik:**
- Setiap lirik disimpan sebagai objek `LyricLine` dengan tiga properti:
  - `text`: Teks lirik yang akan ditampilkan
  - `startTime`: Waktu mulai kapan lirik seharusnya disorot (dalam Duration)
  - `endTime`: Waktu akhir kapan sorotan lirik seharusnya berpindah (dalam Duration)
- Format ini memungkinkan penentuan lirik aktif yang lebih akurat dengan menentukan rentang waktu yang tepat untuk setiap baris lirik
- Membantu dalam implementasi pengguliran otomatis yang tepat waktu

## Alur Kerja Aplikasi

1. Aplikasi dimulai dari `HomePage` yang menampilkan cover art dan opsi navigasi:
   - Tampilan utama dengan gradient background dari biru muda ke putih
   - Cover art lagu ditampilkan dengan efek shadow
   - Informasi judul lagu "XXL" dan artis "LANY"
   - Dua tombol navigasi: "PLAY NOW" dan "VIEW LYRICS"

2. Pengguna dapat memilih untuk:
   - Membuka `MusicPlayerPage` dengan menekan tombol "PLAY NOW" untuk mendengarkan lagu dengan lirik tersinkronisasi
   - Membuka `LyricsOnlyPage` dengan menekan tombol "VIEW LYRICS" untuk melihat lirik secara statis

3. Di `MusicPlayerPage`:
   - Lagu dimulai otomatis saat halaman terbuka
   - Cover art lagu ditampilkan di bagian atas dengan ukuran yang lebih kecil
   - Progress bar menunjukkan posisi pemutaran lagu
   - Kontrol pemutaran (play/pause, rewind 10s, forward 10s)
   - Lirik ditampilkan di bagian bawah dengan scrolling
   - Lirik disorot secara otomatis berdasarkan posisi waktu lagu
   - Sistem pengguliran otomatis pintar memastikan lirik yang aktif selalu terlihat

4. Di `LyricsOnlyPage`:
   - Tampilan statis dari seluruh lirik lagu
   - Judul lagu dan nama artis ditampilkan di bagian atas
   - Lirik ditampilkan dengan format yang konsisten
   - Tombol "PLAY NOW" untuk kembali ke halaman pemutar musik

## Teknologi dan Paket yang Digunakan

- **Flutter**: Framework UI cross-platform untuk pengembangan aplikasi iOS dan Android
- **audioplayers**: Paket untuk pemutaran audio dengan fitur kontrol playback lengkap
- **Material Design**: Sistem desain dari Google untuk UI yang konsisten
- **Animasi Flutter**: Untuk transisi halus dan efek visual pada auto-scrolling lirik
- **ScrollController**: API Flutter untuk kontrol scroll yang presisi pada ListView
- **Timer dan Duration**: API Flutter untuk mengukur dan melacak waktu pemutaran lagu
- **Gradient dan Shadow**: API Flutter untuk styling yang menarik dengan gradient dan efek bayangan

## Instalasi dan Pengembangan

### Prasyarat

- Flutter SDK (versi terbaru)
- Dart SDK (versi terbaru)
- Android Studio / VS Code dengan ekstensi Flutter dan Dart

### Konfigurasi pubspec.yaml

Aplikasi memerlukan dependensi `audioplayers` yang perlu ditambahkan ke `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  audioplayers: ^5.2.0  # Package untuk pemutaran audio
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/  # Untuk cover art lagu
    - assets/audio/   # Untuk file audio
```

### Struktur Assets

Aplikasi mengharapkan file-file berikut dalam folder assets:
- `assets/images/cover.jpg` - Cover art lagu
- `assets/audio/xxl_lany.mp3` - File audio lagu

### Langkah Instalasi

1. Kloning repositori ini
2. Pastikan folder `assets` dengan struktur yang benar ada di root proyek
3. Jalankan `flutter pub get` untuk menginstal dependensi
4. Jalankan `flutter run` untuk memulai aplikasi

## Penjelasan Teknis Tambahan

### Manajemen State dan Siklus Hidup

- **StatefulWidget**: Aplikasi menggunakan `StatefulWidget` untuk mengelola state pemutaran musik dan posisi lirik
- **Event Listeners**: Mendaftarkan listener untuk berbagai event audio:
  ```dart
  // Mendengarkan perubahan durasi lagu
  audioPlayer.onDurationChanged.listen((newDuration) {
    setState(() { duration = newDuration; });
  });
  
  // Mendengarkan perubahan posisi pemutaran
  audioPlayer.onPositionChanged.listen((newPosition) {
    setState(() { 
      position = newPosition;
      _updateCurrentLyricLine(); 
    });
  });
  ```
- **Dispose**: Membersihkan resource saat widget di-dispose:
  ```dart
  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }
  ```

### Sistem Audio

Aplikasi menggunakan paket `audioplayers` dengan fitur lengkap:
- **Pemutaran Dasar**: `audioPlayer.play(AssetSource('audio/xxl_lany.mp3'))`
- **Kontrol Playback**: `audioPlayer.pause()`, `audioPlayer.stop()`
- **Seeking**: `audioPlayer.seek(Duration(seconds: value.toInt()))`
- **Tracking Posisi**: Menggunakan `onPositionChanged` untuk memperbarui posisi pemutaran
- **State Detection**: Menggunakan `onPlayerStateChanged` untuk deteksi state pemutaran

### Desain UI Responsif

UI dirancang dengan pendekatan responsif menggunakan:
- **Gradient Dinamis**: Latar belakang dengan gradient warna untuk estetika visual
  ```dart
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF90e0ef), Color(0xFFcaf0f8)],
    ),
  ),
  ```

- **Layout Adaptif**: Penggunaan `MediaQuery` untuk ukuran yang relatif terhadap layar
  ```dart
  double viewportHeight = MediaQuery.of(context).size.height * 0.4;
  ```

- **Error Handling**: Penanganan error untuk asset yang tidak ditemukan
  ```dart
  errorBuilder: (context, error, stackTrace) {
    return Container(
      // Fallback UI jika gambar tidak ditemukan
    );
  }
  ```

- **Styling Konsisten**: Penggunaan styling yang konsisten untuk tipografi dan warna
  ```dart
  style: TextStyle(
    fontSize: currentLyricIndex == index ? 16 : 15,
    color: currentLyricIndex == index ? Color(0xFF0077b6) : Colors.black87,
    fontWeight: currentLyricIndex == index ? FontWeight.bold : FontWeight.normal,
  )
  ```

## Pengembangan Lebih Lanjut

Beberapa ide untuk pengembangan masa depan:

- **Fitur Playlist**: Menambahkan kemampuan untuk membuat dan memainkan playlist
- **Dukungan Multi-Bahasa**: Implementasi lirik dalam beberapa bahasa dengan opsi switch
- **Fitur Berbagi**: Memungkinkan pengguna berbagi lirik atau bagian lagu ke media sosial
- **Mode Gelap/Terang**: Tema yang dapat diubah sesuai preferensi pengguna
- **Format Audio Tambahan**: Dukungan untuk lebih banyak format file audio
- **Penyesuaian Sinkronisasi**: Memungkinkan pengguna mengatur timing lirik secara manual
- **Offline Storage**: Menyimpan lirik dan lagu untuk akses offline
- **Visualisasi Audio**: Menambahkan visualisasi audio yang responsif terhadap beat lagu
