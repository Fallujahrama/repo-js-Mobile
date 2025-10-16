import 'package:flutter/material.dart';

// void main() {
//   runApp(const ListViewEx());
// }

// class ListViewEx extends StatelessWidget {
//   const ListViewEx({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('ListView'),
//         ),
//         body: ListView(
//           children: [
//             ListTile(title: Text('Item 1'), leading: Icon(Icons.star),),
//             ListTile(title: Text('Item 2'), leading: Icon(Icons.favorite),),
//             ListTile(title: Text('Item 3'), leading: Icon(Icons.home),),
//           ],
//         ),
//       ),
//     );
//   }
// }

void main() {
  runApp(ListViewEx());
}

class ListViewEx extends StatelessWidget {
  final List<String> list = ['Flutter', 'Dart', 'React Native', 'Kotlin', 'Swift'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ListView'),
        ),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.code),
              title: Text(list[index]),
              onTap: () => print('Klik ${list[index]}'),
            );
          },
        ),
      ),
    );
  }
}