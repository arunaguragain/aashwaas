import 'package:aashwaas/app/app.dart';
import 'package:aashwaas/core/services/hive/hive_service.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  final sharedPrefs = await SharedPreferences.getInstance();
  // Migrate auth token from SharedPreferences to secure storage (if present)
  try {
    const secure = FlutterSecureStorage();
    const tokenKey = 'auth_token';
    final existing = sharedPrefs.getString(tokenKey);
    if (existing != null && existing.isNotEmpty) {
      await secure.write(key: tokenKey, value: existing);
      await sharedPrefs.remove(tokenKey);
    }
  } catch (_) {}
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: App(),
    ),
  );
}
