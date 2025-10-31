import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Import untuk menampilkan gambar dari file
import 'package:flutter/foundation.dart'; // Import untuk kIsWeb
import 'package:gal/gal.dart'; // Import untuk save ke gallery (modern plugin)
import 'package:path_provider/path_provider.dart'; // Import untuk path_provider

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

/// CameraApp is the Main Application with Material Design
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  
  // Variabel untuk menyimpan index kamera yang sedang aktif (0 = belakang, 1 = depan)
  int selectedCameraIndex = 0;
  
  // Variabel untuk menyimpan foto yang baru diambil
  XFile? capturedImage;

  @override
  void initState() {
    super.initState();
    // Inisialisasi kamera pertama kali
    initializeCamera(selectedCameraIndex);
  }

  // Method untuk inisialisasi kamera berdasarkan index
  Future<void> initializeCamera(int cameraIndex) async {
    controller = CameraController(_cameras[cameraIndex], ResolutionPreset.high);
    
    try {
      await controller.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  // Method untuk switch/ganti kamera (depan <-> belakang)
  Future<void> switchCamera() async {
    // Ganti index kamera (toggle antara 0 dan 1)
    selectedCameraIndex = (selectedCameraIndex + 1) % _cameras.length;
    
    // Dispose controller lama dan set state untuk rebuild UI
    await controller.dispose();
    setState(() {});
    
    // Inisialisasi kamera baru
    await initializeCamera(selectedCameraIndex);
  }

  // Method untuk mengambil foto
  Future<void> takePicture() async {
    if (!controller.value.isInitialized) {
      return;
    }

    try {
      // Ambil foto dan simpan ke variabel
      final image = await controller.takePicture();
      setState(() {
        capturedImage = image;
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  // Method untuk kembali ke mode kamera (hapus foto yang ditampilkan)
  Future<void> clearImage() async {
    // Dispose controller lama
    await controller.dispose();
    
    // Set state untuk clear image dan rebuild UI
    setState(() {
      capturedImage = null;
    });
    
    // Re-initialize kamera agar preview fresh
    await initializeCamera(selectedCameraIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan loading indicator jika kamera belum siap
    if (!controller.value.isInitialized) {
      return MaterialApp(
        // Implementasi Material Design Theme
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true, // Menggunakan Material Design 3
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Loading Camera...'),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      // Implementasi Material Design Theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Menggunakan Material Design 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: CameraHomePage(
        controller: controller,
        capturedImage: capturedImage,
        selectedCameraIndex: selectedCameraIndex,
        onSwitchCamera: switchCamera,
        onTakePicture: takePicture,
        onClearImage: clearImage,
      ),
    );
  }
}

// Widget terpisah untuk HomePage agar context ScaffoldMessenger benar
class CameraHomePage extends StatelessWidget {
  final CameraController controller;
  final XFile? capturedImage;
  final int selectedCameraIndex;
  final VoidCallback onSwitchCamera;
  final VoidCallback onTakePicture;
  final VoidCallback onClearImage;

  const CameraHomePage({
    super.key,
    required this.controller,
    required this.capturedImage,
    required this.selectedCameraIndex,
    required this.onSwitchCamera,
    required this.onTakePicture,
    required this.onClearImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera App'),
        centerTitle: true,
      ),
      body: capturedImage == null
            // Tampilkan Camera Preview jika belum ada foto yang diambil
            ? Column(
                children: [
                  // Preview kamera mengisi sebagian besar layar
                  Expanded(
                    child: CameraPreview(
                      controller,
                      // Key unik agar widget di-rebuild saat controller berubah
                      key: ValueKey(controller.hashCode),
                    ),
                  ),
                  // Container untuk tombol-tombol kontrol dengan Material Design
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Tombol untuk switch/ganti kamera dengan Material Design
                        Material(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(50),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: onSwitchCamera,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.flip_camera_ios,
                                color: Colors.blue.shade700,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        // Tombol untuk mengambil foto dengan Material Design
                        FloatingActionButton.large(
                          onPressed: onTakePicture,
                          child: Icon(Icons.camera_alt, size: 36),
                          elevation: 4,
                        ),
                        // Tombol info untuk membuka Gallery
                        Material(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(50),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              // Tampilkan SnackBar dengan info
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.info, color: Colors.white),
                                          SizedBox(width: 10),
                                          Text(
                                            'Info Gallery',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text('Buka aplikasi Gallery/Photos di HP untuk melihat foto'),
                                      SizedBox(height: 4),
                                      Text('Lokasi: Pictures/camera_...', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                Icons.photo_library,
                                color: Colors.green.shade700,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            // Tampilkan foto yang baru diambil jika ada
            : DisplayPictureScreen(
                imagePath: capturedImage!.path,
                onRetake: onClearImage,
              ),
    );
  }
}

// Widget terpisah untuk menampilkan foto yang sudah diambil dengan Material Design
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath; // Path file foto
  final VoidCallback onRetake; // Callback untuk tombol Retake

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.onRetake,
  });

  // Method untuk menyimpan foto ke Gallery (Android/iOS)
  Future<void> saveToGallery(BuildContext context) async {
    try {
      if (kIsWeb) {
        // Untuk Web: tampilkan pesan bahwa fitur tidak tersedia
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Save to Gallery tidak tersedia di Web. Foto tersimpan di browser cache.'),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else {
        // Untuk Android/iOS: simpan foto ke Gallery menggunakan Gal
        // Gal adalah plugin modern yang support Android namespace
        await Gal.putImage(imagePath);
        
        // Tampilkan snackbar sukses dengan path file
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Foto berhasil disimpan!'),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Lokasi: Gallery/Pictures',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'File: ${imagePath.split('/').last}',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Error: $e')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Method untuk menampilkan path file foto di layar
  void showPathDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.folder_open, color: Colors.blue),
              SizedBox(width: 10),
              Text('Path File Foto'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi file foto:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SelectableText(
                    imagePath,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(Icons.close),
              label: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview Foto'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onRetake,
          tooltip: 'Kembali ke Kamera',
        ),
      ),
      body: Column(
        children: [
          // Tampilkan foto yang diambil
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: kIsWeb
                    // Untuk Web: gunakan Image.network
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                      )
                    // Untuk Mobile/Desktop: gunakan Image.file
                    : Image.file(
                        File(imagePath),
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
          // Container untuk tombol-tombol dengan Material Design
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Tombol untuk menampilkan path file
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => showPathDialog(context),
                    icon: Icon(Icons.info_outline),
                    label: Text('Lihat Path File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade100,
                      foregroundColor: Colors.blue.shade700,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // Row untuk tombol Retake dan Save
                Row(
                  children: [
                    // Tombol untuk mengambil foto ulang
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onRetake,
                        icon: Icon(Icons.camera_alt),
                        label: Text('Retake'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade600,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Tombol untuk menyimpan foto ke Gallery
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => saveToGallery(context),
                        icon: Icon(Icons.save),
                        label: Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
