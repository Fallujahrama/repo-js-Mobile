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
            // Header
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
            
            // Lyrics - CENTER ALIGNED
            Column(
              children: [
                "All my favorite songs are from 2018",
                "We flew around the world with our small-town dreams",
                "You're a superstar and you wear it so well",
                "But nothin' like you in my hoodie double XL",
                "",
                "Bloodstream full of desert lightnin'",
                "Thank God I'm not drivin'",
                "A blur the whole way home",
                "",
                "I still remember, I will forever",
                "Backseat secrets we won't ever tell, I miss you double XL",
                "Miss Americana and all my friends love ya",
                "Back patio at the Bowery Hotel, I miss you double XL",
                "",
                "You've been goin' out in the glitter and glow",
                "Hollywood fades and it's startin' to show",
                "I'm barely hangin' on and I'm lookin' for help",
                "Every night without you hurtin' double XL",
                "",
                "Bloodstream full of desert lightnin'",
                "Thank God I'm not drivin'",
                "A blur the whole way home",
                "",
                "I still remember, I will forever",
                "Backseat secrets we won't ever tell, I miss you double XL",
                "Miss Americana and all my friends love ya",
                "Back patio at the Bowery Hotel, I miss you double XL",
                "",
                "Baby, we'll always have California",
                "Half of me will always be waitin' for ya",
                "",
                "I still remember, I will forever",
                "Backseat secrets we won't ever tell, I miss you double XL",
                "Miss Americana and all my friends love ya",
                "Back patio at the Bowery Hotel, I miss you double XL",
                "",
                "Baby, we'll always have California",
                "Half of me will always be waitin' for ya",
                "Baby, we'll always have California",
                "Half of me will always be waitin' for ya (I miss you double XL)",
              ].map((line) => Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: line.isEmpty ? 4 : 6), // Adjusted padding to match music player
                child: Center(
                  child: Text(
                    line,
                    style: TextStyle(
                      fontSize: 15, // Slightly smaller text to match music player
                      height: 1.4, // Tighter line spacing to match music player
                      color: Colors.black87,
                      fontFamily: 'Roboto',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )).toList(),
            ),
            
            SizedBox(height: 40),
            
            // Play Button
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
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}