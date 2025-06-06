import 'dart:convert';              
import 'package:http/http.dart' as http;


class UserService {
  final String baseUrl = 'http://10.0.2.2:5277';

  Future<bool> registerUser(Map<String, dynamic> user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final msg = jsonDecode(response.body)['message'] ?? 'Erro ao cadastrar';
        throw Exception(msg);
      }
    } catch (e) {
      return false;
    }
  }
}