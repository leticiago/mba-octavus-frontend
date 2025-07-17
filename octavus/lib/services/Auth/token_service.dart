import 'package:octavus/services/auth/interfaces/i_token_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TokenService implements ITokenService {
  static const _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  @override
  String? extractEmailFromToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = jsonDecode(payload);
    return payloadMap['email'];
  }

  @override
  String? extractNameFromToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = jsonDecode(payload);
    return payloadMap['name'];
  }
}
