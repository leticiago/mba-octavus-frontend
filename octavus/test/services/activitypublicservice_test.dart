import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:octavus/models/activity_model.dart';
import 'package:octavus/services/Activity/activity_public_service.dart';

import '../mocks.mocks.dart';
void main() {
  late MockClient mockClient;
  late MockITokenService mockTokenService;
  late ActivityPublicService service;

  setUp(() {
    mockClient = MockClient();
    mockTokenService = MockITokenService();
    service = ActivityPublicService(
      client: mockClient,
      tokenService: mockTokenService,
    );
  });

  test('deve retornar uma lista de atividades quando a resposta for 200', () async {
    final mockJson = jsonEncode([
      {
        "id": "1",
        "name": "Atividade pública",
        "description": "Descrição da atividade",
        "type": 2,
        "date": "2025-07-14T00:00:00Z",
        "level": 1,
        "isPublic": true,
        "instrumentId": "instr123",
        "professorId": "professor_id",
      }
    ]);

    when(mockTokenService.getToken()).thenAnswer((_) async => 'fake-token');

    when(mockClient.get(
      Uri.parse('http://10.0.2.2:5277/api/activity/public'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(mockJson, 200));

    final result = await service.fetchPublicActivities();

    expect(result, isA<List<Activity>>());
    expect(result.length, 1);
    expect(result.first.name, equals('Atividade pública'));
  });

  test('deve lançar exceção se a resposta não for 200', () async {
    when(mockTokenService.getToken()).thenAnswer((_) async => 'fake-token');

    when(mockClient.get(
      Uri.parse('http://10.0.2.2:5277/api/activity/public'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Erro', 500));

    expect(
      () async => await service.fetchPublicActivities(),
      throwsA(isA<Exception>()),
    );
  });

  test('deve lançar exceção se token for nulo', () async {
    when(mockTokenService.getToken()).thenAnswer((_) async => null);

    expect(
      () async => await service.fetchPublicActivities(),
      throwsA(isA<Exception>().having(
        (e) => e.toString(),
        'message',
        contains('Token de autenticação não encontrado'),
      )),
    );
  });
}
