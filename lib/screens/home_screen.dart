import 'package:flutter/material.dart';

import '../services/auth_service.dart';

/// Placeholder landing screen shown once a user is signed in.
/// Course browsing (Step 4) replaces this screen's body.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    final email = authService.currentUser?.email ?? 'there';
    return Scaffold(
      appBar: AppBar(
        title: const Text('LMS Learning App'),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: authService.signOut,
          ),
        ],
      ),
      body: Center(child: Text('Welcome, $email!')),
    );
  }
}
