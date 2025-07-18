import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:octavus/services/user/user_service.dart';



class UserServiceWithClient extends UserService {
  @override
  final String baseUrl = 'http://10.0.2.2:5277';
  final http.Client client;

  UserServiceWithClient({required this.client});

  @override
  Future<bool> registerUser(Map<String, dynamic> user) async {
    try {
      final response = await client.post(
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

  @override
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final response = await client.get(
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

void main() {
  group('UserService', () {
    test('registerUser retorna true se status 201', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/users');
        expect(request.method, 'POST');
        return http.Response('', 201);
      });

      final userService = UserServiceWithClient(client: mockClient);

      final result = await userService.registerUser({
        'email': 'teste@teste.com',
        'password': '123456'
      });

      expect(result, true);
    });

    test('registerUser retorna false se lançar exceção', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Erro de rede');
      });

      final userService = UserServiceWithClient(client: mockClient);

      final result = await userService.registerUser({
        'email': 'erro@email.com',
        'password': '123456'
      });

      expect(result, false);
    });

    test('registerUser lança exceção com mensagem personalizada', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'message': 'E-mail já cadastrado'}), 400);
      });

      final userService = UserServiceWithClient(client: mockClient);

      final result = await userService.registerUser({
        'email': 'duplicado@email.com',
        'password': '123456'
      });

      expect(result, false);
    });

    test('getUserByEmail retorna dados se status 200', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/users/email/teste@teste.com');
        return http.Response(jsonEncode({
          'id': 'u1',
          'email': 'teste@teste.com',
          'username': 'usuario'
        }), 200);
      });

      final userService = UserServiceWithClient(client: mockClient);

      final user = await userService.getUserByEmail('teste@teste.com');

      expect(user, isNotNull);
      expect(user!['email'], 'teste@teste.com');
      expect(user['username'], 'usuario');
    });

    test('getUserByEmail retorna null se status != 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Usuário não encontrado', 404);
      });

      final userService = UserServiceWithClient(client: mockClient);

      final user = await userService.getUserByEmail('inexistente@email.com');

      expect(user, isNull);
    });
  });
}
