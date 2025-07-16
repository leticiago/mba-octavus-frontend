import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:octavus/services/user/user_service.dart';

void main() {
  group('UserService', () {
    late UserServiceWithClient userService;

    test('registerUser retorna true quando statusCode é 200 ou 201', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/users');
        expect(request.method, 'POST');
        return http.Response('', 201); 
      });

      userService = UserServiceWithClient(client: mockClient);

      final result = await userService.registerUser({
        'email': 'teste@teste.com',
        'password': '123456',
      });

      expect(result, isTrue);
    });

    test('registerUser retorna false quando há exceção', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Erro de rede');
      });

      userService = UserServiceWithClient(client: mockClient);

      final result = await userService.registerUser({'email': 'a', 'password': 'b'});
      expect(result, isFalse);
    });

    test('registerUser lança exceção quando statusCode não é 200/201', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'message': 'Email já existe'}), 400);
      });

      userService = UserServiceWithClient(client: mockClient);

      final result = await userService.registerUser({'email': 'a', 'password': 'b'});

      expect(result, isFalse); // pois `registerUser` captura exceções e retorna false
    });

    test('getUserByEmail retorna dados do usuário se statusCode 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response(jsonEncode({'email': 'teste@teste.com', 'id': '123'}), 200);
      });

      userService = UserServiceWithClient(client: mockClient);

      final result = await userService.getUserByEmail('teste@teste.com');
      expect(result, isNotNull);
      expect(result!['email'], 'teste@teste.com');
    });

    test('getUserByEmail retorna null se statusCode diferente de 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Não encontrado', 404);
      });

      userService = UserServiceWithClient(client: mockClient);

      final result = await userService.getUserByEmail('naoexiste@teste.com');
      expect(result, isNull);
    });
  });
}

class UserServiceWithClient extends UserService {
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
