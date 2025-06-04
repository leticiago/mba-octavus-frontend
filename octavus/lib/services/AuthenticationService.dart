import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/LoginModel.dart';
import 'TokenService.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:5277/api/authentication'; 

  Future<String?> login(UserModel user) async {

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

   

    if (response.statusCode == 200) {
    final token = jsonDecode(response.body)['token'];
    await TokenService.saveToken(token); // salva o token
    return token;
    } else {
      print('Erro ao fazer login: ${response.body}');
      return null;
    }
  }
}
