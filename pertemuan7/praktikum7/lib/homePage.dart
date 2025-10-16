import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/secondPage': (context) => SecondPage(),
    },
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;

  MyApp({required this.initialRoute, required this.routes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/secondPage'),
          child: Text('Go to Second Page'),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Kembali'),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
      ),
    );
  }
}