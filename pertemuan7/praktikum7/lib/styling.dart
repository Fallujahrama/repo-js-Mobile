import 'package:flutter/material.dart';

void main() {
  runApp(const StylingEx());
}

class StylingEx extends StatelessWidget {
  const StylingEx({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Styling'),
        ),
        body: Stack(
          children: [
            Container( color: Colors.lightBlueAccent),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.amber,
                child: Text(
                  "tengah", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}