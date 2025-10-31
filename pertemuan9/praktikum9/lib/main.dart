import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Import untuk menampilkan gambar dari file
import 'package:flutter/foundation.dart'; // Import untuk kIsWeb
import 'package:image_gallery_saver/image_gallery_saver.dart'; // Import untuk save ke gallery
import 'dart:typed_data'; // Import untuk Uint8List

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

/// CameraApp is the Main Application.
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
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Camera App'),
          backgroundColor: Colors.black,
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
                  // Container untuk tombol-tombol kontrol
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Tombol untuk switch/ganti kamera
                        IconButton(
                          onPressed: switchCamera,
                          icon: Icon(Icons.flip_camera_ios, color: Colors.white, size: 30),
                          tooltip: 'Switch Camera',
                        ),
                        // Tombol untuk mengambil foto
                        FloatingActionButton(
                          onPressed: takePicture,
                          child: Icon(Icons.camera_alt, size: 30),
                          backgroundColor: Colors.white,
                        ),
                        // Spacer untuk keseimbangan layout
                        SizedBox(width: 48),
                      ],
                    ),
                  ),
                ],
              )
            // Tampilkan foto yang baru diambil jika ada
            : DisplayPictureScreen(
                imagePath: capturedImage!.path,
                onRetake: clearImage,
              ),
      ),
    );
  }
}

// Widget terpisah untuk menampilkan foto yang sudah diambil
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
            content: Text('Save to Gallery tidak tersedia di Web. Foto tersimpan di browser cache.'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        // Untuk Android/iOS: baca file dan simpan ke Gallery
        final File imageFile = File(imagePath);
        final Uint8List bytes = await imageFile.readAsBytes();
        
        // Simpan ke Gallery dengan nama timestamp
        final result = await ImageGallerySaver.saveImage(
          bytes,
          quality: 100,
          name: 'camera_${DateTime.now().millisecondsSinceEpoch}',
        );
        
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Foto berhasil disimpan ke Gallery!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Gagal menyimpan foto'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Tampilkan foto yang diambil
          Expanded(
            child: kIsWeb
                // Untuk Web: gunakan Image.network
                ? Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                  )
                // Untuk Mobile/Desktop: gunakan Image.file
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
          ),
          // Container untuk tombol Retake dan Save
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tombol untuk mengambil foto ulang
                ElevatedButton.icon(
                  onPressed: onRetake,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Retake'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                // Tombol untuk menyimpan foto ke Gallery
                ElevatedButton.icon(
                  onPressed: () => saveToGallery(context),
                  icon: Icon(Icons.save),
                  label: Text('Save to Gallery'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}