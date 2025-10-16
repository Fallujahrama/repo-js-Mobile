import 'package:flutter/material.dart';

void main() {
  runApp(const ColumnEx());
}

class ColumnEx extends StatelessWidget {
  const ColumnEx({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contoh Column'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Hello Flutter"),
            const Text("Hello Flutter"),
            Text("Hello Flutter"),
            Text("Hello Flutter"),
            ElevatedButton(onPressed: () {}, 
            child: Text("Click Me")),
          ],
        ),
      ),
    );
  }
}