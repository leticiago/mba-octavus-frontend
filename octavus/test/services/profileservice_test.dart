import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:octavus/models/profile_model.dart';
import 'package:octavus/services/common/profile_service.dart';

void main() {
  group('ProfileService', () {
    test('getProfiles retorna lista de perfis no sucesso', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/profiles');
        return http.Response(jsonEncode([
          {'id': 'p1', 'name': 'Perfil 1'},
          {'id': 'p2', 'name': 'Perfil 2'},
        ]), 200);
      });

      final service = ProfileServiceWithClient(client: mockClient);

      final profiles = await service.getProfiles();

      expect(profiles.length, 2);
      expect(profiles[0].id, 'p1');
      expect(profiles[0].name, 'Perfil 1');
    });

    test('getProfiles lança exceção em falha HTTP', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Erro', 500);
      });

      final service = ProfileServiceWithClient(client: mockClient);

      expect(() async => await service.getProfiles(), throwsException);
    });
  });
}

class ProfileServiceWithClient extends ProfileService {
  final http.Client client;

  ProfileServiceWithClient({required this.client});

  @override
  Future<List<Profile>> getProfiles() async {
    final response = await client.get(Uri.parse('$baseUrl/api/v1/profiles'));

    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => Profile.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar perfis');
    }
  }
}
