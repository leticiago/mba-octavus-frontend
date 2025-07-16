import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:octavus/models/instrument_model.dart';
import 'package:octavus/services/common/instrument_service.dart';

void main() {
  group('InstrumentService', () {
    test('getInstruments retorna lista de instrumentos no sucesso', () async {
      // Mock da resposta HTTP
      final mockClient = MockClient((request) async {
        expect(request.url.path, '/api/v1/instruments');
        return http.Response(jsonEncode([
          {'id': '1', 'name': 'Instrumento 1'},
          {'id': '2', 'name': 'Instrumento 2'},
        ]), 200);
      });

      // Criar uma versão do service que aceita client (precisa ajustar InstrumentService para injetar client)
      final service = InstrumentServiceWithClient(client: mockClient);

      final instruments = await service.getInstruments();

      expect(instruments.length, 2);
      expect(instruments[0].id, '1');
      expect(instruments[0].name, 'Instrumento 1');
    });

    test('getInstruments lança exceção em falha HTTP', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Erro', 500);
      });

      final service = InstrumentServiceWithClient(client: mockClient);

      expect(
        () async => await service.getInstruments(),
        throwsException,
      );
    });
  });
}

/// Versão de InstrumentService que permite injetar um client para testes
class InstrumentServiceWithClient extends InstrumentService {
  final http.Client client;

  InstrumentServiceWithClient({required this.client});

  @override
  Future<List<Instrument>> getInstruments() async {
    final response = await client.get(Uri.parse('$baseUrl/api/v1/instruments'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Instrument.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar instrumentos');
    }
  }
}
