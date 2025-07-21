import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:octavus/services/auth/token_service.dart';

class UserService {
  final String baseUrl = 'http://10.0.2.2:5277';
  final TokenService tokenService;

  UserService({TokenService? tokenService})
      : tokenService = tokenService ?? TokenService();

  Future<bool> registerUser(Map<String, dynamic> user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);

        final token = body['token'] as String?;
        final userId = body['id'] ?? body['Id']; 

        if (token != null && userId != null) {
          await tokenService.saveToken(token);
          await _saveUserId(userId.toString());
          return true;
        }

        return false;
      } else {
        final msg = jsonDecode(response.body)['message'] ?? 'Erro ao cadastrar';
        throw Exception(msg);
      }
    } catch (e) {
      print('Erro ao registrar usuário: $e');
      return false;
    }
  }

  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/email/$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
