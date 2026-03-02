import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:aashwaas/core/config/google_config.dart';

class GoogleSignInService {
  GoogleSignInService();

  /// Signs in the user with Google and returns the ID token (or null if cancelled).
  /// Throws an [Exception] with a descriptive message on failure.
  Future<String?> signInAndGetIdToken({
    bool forceAccountSelection = false,
  }) async {
    try {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: GoogleConfig.webClientId,
      );

      if (forceAccountSelection) {
        try {
          await googleSignIn.signOut();
        } catch (_) {}
        try {
          await googleSignIn.disconnect();
        } catch (_) {}
      }

      final account = await googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;
      return auth.idToken;
    } on PlatformException catch (e) {
      // Surface a clearer message for Android sign-in failures (ApiException: 10)
      final code = e.code;
      final message = e.message ?? e.toString();
      throw Exception('Google sign-in failed ($code): $message');
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
