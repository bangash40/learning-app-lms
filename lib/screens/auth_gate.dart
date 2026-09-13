import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Root routing widget: shows [HomeScreen] while a user is signed in, and
/// [LoginScreen] otherwise. Rebuilds automatically whenever Firebase's auth
/// state changes (sign in, sign up, sign out).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return HomeScreen(authService: authService);
        }
        return LoginScreen(authService: authService);
      },
    );
  }
}
