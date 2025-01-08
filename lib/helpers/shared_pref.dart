import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _keyIsGoogleLoggedIn = "is_google_logged_in";
  static const String _keyUserName = "user_name";
  static const String _keyEmail = "email";
  static const String _keyIsGuestLoggedIn = "is_guest_logged_in";


  Future<void> saveGoogleLoginStatus({
    required bool isLoggedIn,
    String? userName,
    String? email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsGoogleLoggedIn, isLoggedIn);
    if (userName != null) {
      await prefs.setString(_keyUserName, userName);
    }
    if (email != null) {
      await prefs.setString(_keyEmail, email);
    }
  }
  Future<void> saveGuestLoginStatus({required bool isLoggedIn}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsGuestLoggedIn, isLoggedIn);
  }

  Future<bool> isGuestLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsGuestLoggedIn) ?? false;
  }
  Future<bool> isGoogleLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsGoogleLoggedIn) ?? false;
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsGoogleLoggedIn);
    await prefs.remove(_keyIsGuestLoggedIn);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyEmail);
  }
}
