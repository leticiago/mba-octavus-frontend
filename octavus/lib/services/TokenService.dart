import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenService {
  static const _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static String? extractEmailFromToken(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return null;

  final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
  final payloadMap = jsonDecode(payload);

  return payloadMap['email'];
 }

 static String? extractNameFromToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = jsonDecode(payload);

    return payloadMap['name'];
  }
}
