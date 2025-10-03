import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

// Model for a line of lyrics with timing information
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
  
  @override
  void initState() {
    super.initState();
    
    audioPlayer = AudioPlayer();
    
    // Listen to duration changes
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });
    
    // Listen to position changes
    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
          // Update the current lyric line based on position
          _updateCurrentLyricLine();
        });
      }
    });
    
    // Listen to player state changes
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
  }
  
  // Find which lyric line should be highlighted based on the current position
  void _updateCurrentLyricLine() {
    // Find the current lyric line
    int newIndex = -1;
    
    for (int i = 0; i < syncedLyrics.length; i++) {
      LyricLine line = syncedLyrics[i];
      if (position >= line.startTime && position <= line.endTime) {
        newIndex = i;
        break;
      }
      
      // If we're past the start time of this line but not yet at the next line's start
      if (position >= line.startTime && 
          (i == syncedLyrics.length - 1 || position < syncedLyrics[i + 1].startTime)) {
        newIndex = i;
        break;
      }
    }
    
    // Only update UI and scroll if the index has changed
    if (currentLyricIndex != newIndex && newIndex >= 0) {
      setState(() {
        currentLyricIndex = newIndex;
      });
      
      // Auto-scroll to the current line
      _scrollToCurrentLine();
    }
  }
  
  // Automatically scroll to the highlighted line
  void _scrollToCurrentLine() {
    if (currentLyricIndex >= 0 && _scrollController.hasClients) {
      // Calculate the approximate height of each line (including padding)
      double lineHeight = 30.0;
      
      // Cek apakah line yang sedang aktif sudah visible di layar
      bool isLineVisible = _isLyricLineVisible(currentLyricIndex);
      
      // Jika sudah di bagian lirik akhir (index >= 24), kurangi intensitas scroll
      double scrollOffset;
      if (currentLyricIndex >= 24) {
        // Untuk lirik akhir, scroll minimal saja untuk membuat lirik terlihat
        // Hanya scroll jika lirik tidak terlihat
        if (!isLineVisible) {
          // Scroll hanya sedikit di bawah posisi sekarang untuk menampilkan line saat ini
          scrollOffset = _scrollController.offset + lineHeight;
          
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
        // Jika lirik sudah terlihat, tidak perlu scroll
        return;
      }
      
      // Untuk lirik di bagian awal dan tengah, scroll seperti biasa ke tengah viewport
      double viewportHeight = MediaQuery.of(context).size.height * 0.4; // Approximate lyrics area height
      scrollOffset = (currentLyricIndex * lineHeight) - (viewportHeight / 2) + (lineHeight / 2);
      
      // Make sure we don't go negative
      scrollOffset = scrollOffset < 0 ? 0 : scrollOffset;
      
      // Check if we're near the end of the list - don't over-scroll
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
  
  // Helper method to check if a lyric line is already visible on screen
  bool _isLyricLineVisible(int index) {
    if (!_scrollController.hasClients) return false;
    
    // Calculate approximate position of the line
    double lineHeight = 30.0;
    double lineTop = index * lineHeight;
    double lineBottom = lineTop + lineHeight;
    
    // Get current scroll viewport boundaries
    double scrollTop = _scrollController.offset;
    double scrollBottom = scrollTop + MediaQuery.of(context).size.height * 0.4;
    
    // Line is visible if its top or bottom is within the viewport
    return (lineTop >= scrollTop && lineTop <= scrollBottom) ||
           (lineBottom >= scrollTop && lineBottom <= scrollBottom);
  }
  
  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }
  
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
  
  // Track the currently highlighted lyric line
  int currentLyricIndex = -1;
  final ScrollController _scrollController = ScrollController();
  
  // Lyrics with timing information (timestamps in seconds)
  final List<LyricLine> syncedLyrics = [
    LyricLine(text: "All my favorite songs are from 2018", startTime: Duration(seconds: 9), endTime: Duration(seconds: 11)),
    LyricLine(text: "We flew around the world with our small-town dreams", startTime: Duration(seconds: 12), endTime: Duration(seconds: 15)),
    LyricLine(text: "You're a superstar and you wear it so well", startTime: Duration(seconds: 15), endTime: Duration(seconds: 18)),
    LyricLine(text: "But nothin' like you in my hoodie double XL", startTime: Duration(seconds: 18), endTime: Duration(seconds: 21)),

    LyricLine(text: "Bloodstream full of desert lightnin'", startTime: Duration(seconds: 21), endTime: Duration(seconds: 25)),
    LyricLine(text: "Thank God I'm not drivin'", startTime: Duration(seconds: 26), endTime: Duration(seconds: 29)),
    LyricLine(text: "A blur the whole way home", startTime: Duration(seconds: 29), endTime: Duration(seconds: 32)),

    LyricLine(text: "I still remember, I will forever", startTime: Duration(seconds: 35), endTime: Duration(seconds: 40)),
    LyricLine(text: "Backseat secrets we won't ever tell, I miss you double XL", startTime: Duration(seconds: 40), endTime: Duration(seconds: 47)),
    LyricLine(text: "Miss Americana and all my friends love ya", startTime: Duration(seconds: 47), endTime: Duration(seconds: 53)),
    LyricLine(text: "Back patio at the Bowery Hotel, I miss you double XL", startTime: Duration(seconds: 53), endTime: Duration(seconds: 59)),
    // jeda musik sedikit
    LyricLine(text: "You've been goin' out in the glitter and glow", startTime: Duration(seconds: 72), endTime: Duration(seconds: 75)),
    LyricLine(text: "Hollywood fades and it's startin' to show", startTime: Duration(seconds: 75), endTime: Duration(seconds: 78)),
    LyricLine(text: "I'm barely hangin' on and I'm lookin' for help", startTime: Duration(seconds: 78), endTime: Duration(seconds: 81)),
    LyricLine(text: "Every night without you hurtin' double XL", startTime: Duration(seconds: 82), endTime: Duration(seconds: 84)),

    LyricLine(text: "Bloodstream full of desert lightnin'", startTime: Duration(seconds: 85), endTime: Duration(seconds: 89)),
    LyricLine(text: "Thank God I'm not drivin'", startTime: Duration(seconds: 90), endTime: Duration(seconds: 93)),
    LyricLine(text: "A blur the whole way home", startTime: Duration(seconds: 93), endTime: Duration(seconds: 96)),

    LyricLine(text: "I still remember, I will forever", startTime: Duration(seconds: 98), endTime: Duration(seconds: 104)),
    LyricLine(text: "Backseat secrets we won't ever tell, I miss you double XL", startTime: Duration(seconds: 104), endTime: Duration(seconds: 110)),
    LyricLine(text: "Miss Americana and all my friends love ya", startTime: Duration(seconds: 110), endTime: Duration(seconds: 116)),
    LyricLine(text: "Back patio at the Bowery Hotel, I miss you double XL", startTime: Duration(seconds: 116), endTime: Duration(seconds: 123)),

    LyricLine(text: "Baby, we'll always have California", startTime: Duration(seconds: 134), endTime: Duration(seconds: 140)),
    LyricLine(text: "Half of me will always be waitin' for ya", startTime: Duration(seconds: 141), endTime: Duration(seconds: 147)),

    LyricLine(text: "I still remember, I will forever", startTime: Duration(seconds: 149), endTime: Duration(seconds: 154)),
    LyricLine(text: "Backseat secrets we won't ever tell, I miss you double XL", startTime: Duration(seconds: 155), endTime: Duration(seconds: 161)),
    LyricLine(text: "Miss Americana and all my friends love ya", startTime: Duration(seconds: 161), endTime: Duration(seconds: 167)),
    LyricLine(text: "Back patio at the Bowery Hotel, I miss you double XL", startTime: Duration(seconds: 167), endTime: Duration(seconds: 173)),

    LyricLine(text: "Baby, we'll always have California", startTime: Duration(seconds: 173), endTime: Duration(seconds: 179)),
    LyricLine(text: "Half of me will always be waitin' for ya", startTime: Duration(seconds: 179), endTime: Duration(seconds: 185)),
    LyricLine(text: "Baby, we'll always have California", startTime: Duration(seconds: 185), endTime: Duration(seconds: 191)),
    LyricLine(text: "Half of me will always be waitin' for ya (I miss you double XL)", startTime: Duration(seconds: 191), endTime: Duration(seconds: 200)),
  ];
  
  // Convenience list for displaying just the text
  List<String> get lyricsLines => syncedLyrics.map((line) => line.text).toList();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        await audioPlayer.stop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Now Playing - XXL by LANY',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xFF03045e),
          foregroundColor: Colors.white,
          elevation: 10,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              await audioPlayer.stop();
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: Column(
          children: [
            // Album Art Area
            Container(
              height: 170, // Reduced height from 220 to 170
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00b4d8), Color(0xFF0077b6)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/cover.jpg',
                    height: 130, // Reduced height from 180 to 130
                    width: 130, // Reduced width from 180 to 130
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 130,
                        width: 130,
                        color: Color(0xFF0077b6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.music_note,
                              size: 60, // Reduced from 80 to 60
                              color: Colors.white,
                            ),
                            SizedBox(height: 5), // Reduced from 10 to 5
                            Text(
                              'XXL',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'LANY',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Progress Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 4.0, // Thinner track
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0), // Smaller thumb
                    ),
                    child: Slider(
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      activeColor: Color(0xFF0077b6),
                      inactiveColor: Color(0x4D90e0ef),
                      onChanged: (value) async {
                        final newPosition = Duration(seconds: value.toInt());
                        await audioPlayer.seek(newPosition);
                        // Manually update position to trigger lyrics highlighting
                        setState(() {
                          position = newPosition;
                          _updateCurrentLyricLine();
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0), // Reduced vertical padding
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatTime(position),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12), // Smaller text
                        ),
                        Text(
                          formatTime(duration),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12), // Smaller text
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Controls
            Container(
              padding: EdgeInsets.symmetric(vertical: 10), // Reduced padding from 20 to 10
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () async {
                      final newPosition = position - Duration(seconds: 10);
                      final seekPosition = newPosition > Duration.zero ? newPosition : Duration.zero;
                      await audioPlayer.seek(seekPosition);
                      // Manually update position to trigger lyrics highlighting
                      setState(() {
                        position = seekPosition;
                        _updateCurrentLyricLine();
                      });
                    },
                    icon: Icon(Icons.replay_10),
                    iconSize: 36, // Reduced size from 40 to 36
                    color: Color(0xFF03045e),
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        if (isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.play(AssetSource('audio/xxl_lany.mp3'));
                          // Reset current lyric index if starting from beginning
                          if (position.inSeconds < 1) {
                            setState(() {
                              currentLyricIndex = -1;
                            });
                          }
                        }
                      } catch (e) {
                        print('Error playing audio: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error playing audio: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12), // Reduced padding from 15 to 12
                      decoration: BoxDecoration(
                        color: Color(0xFF03045e),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x4D90e0ef),
                            spreadRadius: 3, // Reduced from 5 to 3
                            blurRadius: 8, // Reduced from 10 to 8
                          ),
                        ],
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 36, // Reduced from 40 to 36
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final newPosition = position + Duration(seconds: 10);
                      final seekPosition = newPosition < duration ? newPosition : duration;
                      await audioPlayer.seek(seekPosition);
                      // Manually update position to trigger lyrics highlighting
                      setState(() {
                        position = seekPosition;
                        _updateCurrentLyricLine();
                      });
                    },
                    icon: Icon(Icons.forward_10),
                    iconSize: 36, // Reduced from 40 to 36
                    color: Color(0xFF03045e),
                  ),
                ],
              ),
            ),
            
            // Lyrics
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  // Add a subtle border at the top to separate the lyrics section
                  border: Border(
                    top: BorderSide(
                      color: Color(0x1A0077b6), // Very light blue border
                      width: 1.0,
                    ),
                  ),
                ),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(), // Smoother scrolling
                  itemCount: syncedLyrics.length,
                  itemBuilder: (context, index) {
                    // Adjust padding for empty lines
                    final bool isEmptyLine = syncedLyrics[index].text.isEmpty;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: isEmptyLine ? 4 : 6),
                      child: Container(
                        padding: currentLyricIndex == index 
                            ? EdgeInsets.symmetric(vertical: 4, horizontal: 6)
                            : EdgeInsets.zero,
                        decoration: currentLyricIndex == index 
                            ? BoxDecoration(
                                color: Color(0x1A0077b6), // Very light blue background
                                borderRadius: BorderRadius.circular(8),
                              )
                            : null,
                        child: Text(
                          syncedLyrics[index].text,
                          style: TextStyle(
                            fontSize: currentLyricIndex == index ? 16 : 15, // Slightly larger for active line
                            height: 1.4, // Tighter line spacing
                            color: currentLyricIndex == index 
                                ? Color(0xFF0077b6) // Highlight color - active blue
                                : Colors.black87,
                            fontWeight: currentLyricIndex == index 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}