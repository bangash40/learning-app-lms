import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'config/firebase_options.dart';
import 'screens/auth_gate.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: AuthGate(authService: AuthService()),
    );
  }
}
