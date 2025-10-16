import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilEx());
}

class ProfilEx extends StatelessWidget {
  const ProfilEx({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/avatar.png"),
            ),
            SizedBox(height: 20),
            Text(
              "Fallujah Ramadi",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "fallujah@gmail.com",
              style: TextStyle(fontSize: 18),
            ),
          ],
        )
      ),
    );
  }
}