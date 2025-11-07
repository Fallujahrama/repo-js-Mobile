import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// model sederhana
class AppSettings {
  bool isDarkMode = false;
  String username = "Teman";
  int fontSize = 20;

  Color get backgroundColor {
    return isDarkMode ? Colors.grey[900]! : Colors.white;
  }

  Color get textColor {
    return isDarkMode ? Colors.white : Colors.black;
  }

  String get greeting {
    return "Hello, $username!";
  }
}

//vier + state
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //model
  AppSettings settings = AppSettings();

  //fungsi update mode
  void toggleTheme() {
    setState(() {
      settings.isDarkMode = !settings.isDarkMode;
    });
  }

  void updateName(String newName) {
    setState(() {
      settings.username = newName;
    });
  }

  void increaseFont() {
    setState(() {
      settings.fontSize += 2;
    });
  }

  void decreaseFont() {
    setState(() {
      settings.fontSize -= 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: settings.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        backgroundColor: settings.backgroundColor,
        appBar: AppBar(
          title: Text('Aplikasi Settings Sederhana'),
          backgroundColor: settings.isDarkMode ? Colors.blueGrey[900] : Colors.blue,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //tampilkan data dari model
              Text(
                settings.greeting,
                style: TextStyle(
                  fontSize: settings.fontSize.toDouble(),
                  color: settings.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),

              //Status Theme
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mode: ${settings.isDarkMode ? "Gelap" : "Terang"}',
                      style: TextStyle(
                        fontSize: 16,
                        color: settings.textColor,
                      ),
                    ),
                    Switch(
                      value: settings.isDarkMode,
                      onChanged: (value) => toggleTheme(),
                      activeThumbColor: Colors.blue,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              //input nama
              TextField(
                onChanged: updateName,
                decoration: InputDecoration(
                  labelText: 'Masukan Nama',
                  labelStyle: TextStyle(color: settings.textColor),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: settings.isDarkMode ? Colors.grey[900] : Colors.white,
                ),
                style: TextStyle(color: settings.textColor),
              ),
              SizedBox(height: 20),

              //ukuran font
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? Colors.blueGrey[800] : Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      'Ukuran Font: ${settings.fontSize}',
                      style: TextStyle(
                        fontSize: 16,
                        color: settings.textColor,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: decreaseFont,
                          icon: Icon(Icons.remove_circle), color: settings.textColor
                        ),
                        SizedBox(width: 20,),
                        IconButton(
                          onPressed: increaseFont,
                          icon: Icon(Icons.add_circle), color: settings.textColor
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),

              //preview text
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: settings.textColor.withAlpha(50)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Ini adalah preview teks dengan ukuran font ${settings.fontSize}.',
                  style: TextStyle(
                    fontSize: settings.fontSize.toDouble(),
                    color: settings.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: toggleTheme,
          child: Icon(settings.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          backgroundColor: settings.isDarkMode ? Colors.blueGrey[800] : Colors.blue,
        ),
      )
    );
  }
}