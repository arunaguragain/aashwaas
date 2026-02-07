import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Shared prefs provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    "Shared prefs lai hamile main.dart ma initialize garicha ",
  );
});

//provider
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  //Keys for storing data
  static const String _keysIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserPhoneNumber = 'user_phone_number';
  static const String _keyUserProfileImage = 'user_profile_image';
  static const String _keyUserCreatedAt = 'user_created_at';

  //Store user session data
  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String fullName,
    required String? phoneNumber,
    String? profileImage,
    String? createdAt,
    required String role,
  }) async {
    await _prefs.setBool(_keysIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserFullName, fullName);
    if (phoneNumber != null) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    }
    if (profileImage != null) {
      await _prefs.setString(_keyUserProfileImage, profileImage);
    }
    if (createdAt != null) {
      await _prefs.setString(_keyUserCreatedAt, createdAt);
    }
    await setUserRole(role);
  }

  //Clear user session data
  Future<void> clearUserSession() async {
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keysIsLoggedIn);
    await _prefs.remove(_keyUserProfileImage);
    await _prefs.remove(_keyUserCreatedAt);
    await _prefs.remove('user_role');
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keysIsLoggedIn) ?? false;
  }

  String? getUserId() {
    return _prefs.getString(_keyUserId);
  }

  String? getCurrentUserId() {
    return _prefs.getString(_keyUserId);
  }

  String? getUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  String? getUserFullName() {
    return _prefs.getString(_keyUserFullName);
  }

  String? getUserPhoneNumber() {
    return _prefs.getString(_keyUserPhoneNumber);
  }

  String? getUserProfileImage() {
    return _prefs.getString(_keyUserProfileImage);
  }

  String? getUserCreatedAt() {
    return _prefs.getString(_keyUserCreatedAt);
  }

  Future<void> updateUserProfile({
    String? fullName,
    String? phoneNumber,
    String? profileImage,
  }) async {
    if (fullName != null) {
      await _prefs.setString(_keyUserFullName, fullName);
    }
    if (phoneNumber != null) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    }
    if (profileImage != null) {
      await _prefs.setString(_keyUserProfileImage, profileImage);
    }
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'user_role',
    ); // Get user role (either 'volunteer' or 'donor')
  }

  String? getUserRoleSync() {
    return _prefs.getString('user_role');
  }

  Future<void> setUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'user_role',
      role,
    ); // Save the user role (either 'volunteer' or 'donor')
  }
}
