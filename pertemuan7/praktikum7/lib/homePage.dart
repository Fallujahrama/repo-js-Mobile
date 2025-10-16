import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
      GoRoute(path: '/secondPage', builder: (context, state) => SecondPage()),
    ],
  );
  runApp(MaterialApp.router(
    routerConfig: router,
  ));
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
          onPressed: () => context.go('/secondPage'),
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
          onPressed: () => context.go('/'),
        ),
      ),
    );
  }
}