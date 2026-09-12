import 'package:flutter/material.dart';

void main() {
  runApp(const LmsApp());
}

/// Root widget of the LMS Learning App.
/// Screens, services, models, config, and widgets each live in their own
/// folder under lib/ — see README.md for the project structure.
class LmsApp extends StatelessWidget {
  const LmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LMS Learning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(child: Text('LMS Learning App')),
      ),
    );
  }
}
