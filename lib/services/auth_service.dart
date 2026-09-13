import 'package:firebase_auth/firebase_auth.dart';

/// Thin wrapper around [FirebaseAuth] so the rest of the app (screens,
/// widgets) never imports the Firebase SDK directly. If auth needs to move
/// to a different backend later, only this file has to change.
class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  /// Emits the signed-in user (or null) on every auth state change,
  /// including once immediately with the current state on app start.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signUp({required String email, required String password}) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signIn({required String email, required String password}) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  /// Converts a [FirebaseAuthException] into a message safe to show in the UI.
  String messageFor(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Please choose a stronger password (6+ characters).';
      default:
        return exception.message ?? 'Something went wrong. Please try again.';
    }
  }
}
