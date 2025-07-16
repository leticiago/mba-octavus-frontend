import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:octavus/models/login_model.dart' show User;
import 'package:octavus/services/auth/token_service.dart';
import 'User_Session_Service.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5277/api/authentication';
  final String userBaseUrl = 'http://10.0.2.2:5277/api/users';

  final tokenService = TokenService(); 

  Future<String?> login(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      await tokenService.saveToken(token); 

      final email = tokenService.extractEmailFromToken(token);
      if (email != null) {
        final userData = await getUserByEmail(email);
        if (userData != null && userData['id'] != null) {
          await UserSessionService.saveUserId(userData['id']);
        }
      }

      return token;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final token = await tokenService.getToken();

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$userBaseUrl/email/$email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
