class GoogleConfig {
  GoogleConfig._();

  // Replace these with your actual client IDs from Google Cloud Console
  // Use web client id for serverClientId when exchanging idToken on backend
  static const String webClientId =
      '437420983219-9jmpa5ml20qj5ggt90mmsp75hvefnu23.apps.googleusercontent.com';

  // Optionally add Android/iOS client IDs if you need platform-specific logic
  static const String androidClientId = '437420983219-2vb7u35gm87v4lpddv01s78fitgtqa1q.apps.googleusercontent.com';
  static const String iosClientId = '';
}
