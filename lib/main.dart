import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'config/firebase_options.dart';
import 'screens/auth_gate.dart';
import 'services/auth_service.dart';
import 'services/lms_api_service.dart';
import 'services/progress_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const LearningAppLms());
}

/// Root widget of the Learning App LMS.
/// Screens, services, models, config, and widgets each live in their own
/// folder under lib/ — see README.md for the project structure.
class LearningAppLms extends StatelessWidget {
  const LearningAppLms({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final apiService = LmsApiService();
    // Progress is stored per signed-in user, so this is only ever read once
    // AuthGate has already confirmed a user is signed in.
    final progressService = ProgressService(
      uidProvider: () => authService.currentUser!.uid,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning App LMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: AuthGate(
        authService: authService,
        apiService: apiService,
        progressService: progressService,
      ),
    );
  }
}
