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
              
              SizedBox(height: 40),
              
              // Song Title and Artist
              Text(
                'XXL',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF03045e),
                ),
              ),
              Text(
                'by LANY',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0077b6),
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.5,
                ),
              ),
              
              Spacer(),
              
              // Play Button
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MusicPlayerPage()),
                    );
                  },
                  icon: Icon(Icons.play_circle_filled, size: 36),
                  label: Text(
                    'PLAY NOW',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF03045e),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    shadowColor: Color(0xFF90e0ef),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // View Lyrics Button
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LyricsOnlyPage()),
                  );
                },
                child: Text(
                  'VIEW LYRICS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0077b6),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              
              SizedBox(height: 40),
              
              // Copyright
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  '© Project App Lyrics - 2025',
                  style: TextStyle(
                    color: Color(0xFF00b4d8),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

