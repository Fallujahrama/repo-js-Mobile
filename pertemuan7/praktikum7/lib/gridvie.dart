import 'package:flutter/material.dart';

void main() {
  runApp(GridViewEx());
}

class GridViewEx extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GridView Example'),
        ),
        body: GridView.count(
          crossAxisCount: 6,
          children: List.generate(6, (index) {
            return Card(
              color: Colors.amber,
              margin: EdgeInsets.all(16),
              child: Center(
                child: Text('Item ${index + 1}', style: TextStyle(fontSize: 16),),
              ),
            );
          }
          )
        ),
      ),
    );
  }
} 