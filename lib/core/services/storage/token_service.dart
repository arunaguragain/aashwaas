import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// provider
final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService();
});

class TokenService {
  static const String _tokenKey = 'auth_token';
  final FlutterSecureStorage _secureStorage;

  TokenService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  // Save token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  // Get token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  // Remove token (for logout)
  Future<void> removeToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }
}
