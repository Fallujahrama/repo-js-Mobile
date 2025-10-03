import 'package:flutter/material.dart';

void main() {
  runApp(UjahApp());
}

class UjahApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fallujah App',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Fallujah Ramadi C', 
            style: TextStyle(
              color: Colors.white, 
              fontStyle: FontStyle.italic, 
              fontFamily: 'Roboto', 
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
          elevation: 10,
          shadowColor: Colors.grey,
        ),
        body: const Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "\n\nBalonku ada lima",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Balonku ada lima\nRupa-rupa warnanya\nHijau, kuning, kelabu\nMerah muda dan biru\n",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Meletus balon hijau",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text("DORRRR!",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 19, 255, 15),
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1.0, 1.0),
                              blurRadius: 2.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Hatiku sangat kacau\nBalonku tinggal empat\nKupegang erat-erat",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}