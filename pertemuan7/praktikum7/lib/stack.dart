import 'package:flutter/material.dart';

void main() {
  runApp(const StackEx());
}

class StackEx extends StatelessWidget {
  const StackEx({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stack'),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.red,
            ),
            Container(
              width: 150,
              height: 150,
              color: Colors.blue,
            ),
            Text(
              "Tumpukan", 
              style: TextStyle(fontSize: 30, color: Colors.white
              ),
            )
          ],
        ),
      ),
    );
  }
}