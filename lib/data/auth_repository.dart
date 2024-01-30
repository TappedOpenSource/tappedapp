import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Stream<User?> get userChanges;
  Stream<User?> get authStateChanges;
  Future<bool> isSignedIn();
  Future<String> getAuthUserId();
  Future<User?> getAuthUser();
  Future<bool> getAdminClaim();
  Future<Option<String>> getStripeClaim();
  Future<List<CustomClaim>> getCustomClaims();
  Future<Option<SignInPayload>> signInWithCredentials(
    String email,
    String password,
  );
  Future<void> reauthenticateWithCredentials(
    String email,
    String password,
  );
  Future<Option<SignInPayload>> signUpWithCredentials(
    String email,
    String password,
  );
  Future<Option<SignInPayload>> signInWithGoogle();
  Future<void> reauthenticateWithGoogle();
  Future<Option<SignInPayload>> signInWithApple();
  Future<void> reauthenticateWithApple();
  Future<void> logout();
  Future<void> recoverPassword({String email});
  Future<void> deleteUser();
}

class SignInPayload {
  SignInPayload({
    required this.uid,
    required this.displayName,
    required this.email,
  });

  final String uid;
  final String displayName;
  final String email;
}

enum CustomClaim {
  admin,
  booker,
  premium,
}
