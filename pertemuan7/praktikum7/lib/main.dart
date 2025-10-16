import 'package:flutter/material.dart';

void main() {
  runApp(const SingleChildEx());
}

class SingleChildEx extends StatelessWidget {
  const SingleChildEx({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Single Child'),
        ),
        body: Center(
          child: Text("Hello Flutter", style: TextStyle(fontSize: 30)),
        ),
      ),
    );
  }
}