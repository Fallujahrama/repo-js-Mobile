import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

// Kelas untuk custom theme colors
class CustomColors {
  static const Color primaryColor = Color(0xFF2196F3); // Blue
  static const Color secondaryColor = Color(0xFF03A9F4); // Light Blue
  static const Color accentColor = Color(0xFFFF9800); // Orange
  static const Color textPrimary = Color(0xFF212121); // Dark Grey
  static const Color textSecondary = Color(0xFF757575); // Grey
  static const Color background = Color(0xFFF5F5F5); // Light Grey
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Profile & Counter App',
      theme: ThemeData(
        // Custom color scheme
        colorScheme: ColorScheme(
          primary: CustomColors.primaryColor,
          secondary: CustomColors.secondaryColor,
          surface: Colors.white,
          // ignore: deprecated_member_use
          background: CustomColors.background,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: CustomColors.textPrimary,
          // ignore: deprecated_member_use
          onBackground: CustomColors.textPrimary,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        // Google fonts untuk seluruh aplikasi
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        // Tambahan kustomisasi
        appBarTheme: AppBarTheme(
          backgroundColor: CustomColors.primaryColor,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.secondaryColor,
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.poppins(),
          ),
        ),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Mahasiswa',
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
        ),
        backgroundColor: CustomColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Info',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('About', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  content: Text(
                    'Aplikasi ini dibuat untuk tugas pertemuan 6 Flutter.',
                    style: GoogleFonts.poppins(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Counter',
          ),
        ],
        currentIndex: 0, // Set the current index to highlight the selected item
        selectedItemColor: CustomColors.primaryColor,
        onTap: (index) {
          if (index == 1) {
            // Navigate to the Counter page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CounterPage()),
            );
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Flutter Logo
            const FlutterLogo(size: 50),
            const SizedBox(height: 15),
            // Foto Profil
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: CustomColors.primaryColor, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/profil.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback jika gambar tidak ditemukan
                    return const Center(
                      child: Icon(Icons.person, size: 100, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            // const Placeholder(
            //   fallbackHeight: 20,
            //   fallbackWidth: 20,
            //   color: Colors.red,
            // ),
            const SizedBox(height: 20),
            // Nama, NIM, dan Jurusan
            Text(
              'Fallujah Ramadi C',
              style: GoogleFonts.montserrat(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'NIM: 2341760005',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: CustomColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prodi Sistem Informasi Bisnis',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: CustomColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            // Informasi kontak dengan icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.email, color: CustomColors.secondaryColor),
                const SizedBox(width: 8),
                Text(
                  '2341760004@student.polinema.ac.id',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: CustomColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, color: CustomColors.secondaryColor),
                const SizedBox(width: 8),
                Text(
                  '0857 1804 0815',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: CustomColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            // Social Media IconButtons (Bonus Feature)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                  color: CustomColors.accentColor,
                  iconSize: 30,
                  tooltip: 'Instagram',
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.code),
                  color: CustomColors.primaryColor,
                  iconSize: 30,
                  tooltip: 'GitHub',
                ),
                const SizedBox(width: 15),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.business_center),
                  color: CustomColors.secondaryColor,
                  iconSize: 30,
                  tooltip: 'LinkedIn',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;

  void _incrementCounter() {
    setState(() {
      counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (counter > 0) {
        counter--;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Counter App',
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold),
        ),
        backgroundColor: CustomColors.primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Counter',
            onPressed: _resetCounter,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Counter',
          ),
        ],
        currentIndex: 1, // Set the current index to highlight Counter tab
        selectedItemColor: CustomColors.primaryColor,
        onTap: (index) {
          if (index == 0) {
            // Navigate back to Profile page
            Navigator.pop(context);
          }
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Angka Saat ini:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: CustomColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$counter',
              style: GoogleFonts.montserrat(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: CustomColors.primaryColor,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    '-',
                    style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: _resetCounter,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: CustomColors.primaryColor, width: 1),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    'Reset',
                    style: GoogleFonts.poppins(
                      fontSize: 18, 
                      color: CustomColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _incrementCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text(
                    '+',
                    style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}