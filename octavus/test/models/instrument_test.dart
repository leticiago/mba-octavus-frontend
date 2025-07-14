import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/instrument_model.dart';

void main() {
  group('Instrument', () {
    test('Deve criar uma instância corretamente', () {
      final instrument = Instrument(id: '1', name: 'Violino');

      expect(instrument.id, '1');
      expect(instrument.name, 'Violino');
    });

    test('fromJson deve converter JSON em objeto Instrument corretamente', () {
      final json = {'id': '2', 'name': 'Piano'};

      final instrument = Instrument.fromJson(json);

      expect(instrument.id, '2');
      expect(instrument.name, 'Piano');
    });

    test('toJson deve converter objeto Instrument em JSON corretamente', () {
      final instrument = Instrument(id: '3', name: 'Guitarra');

      final json = instrument.toJson();

      expect(json['id'], '3');
      expect(json['name'], 'Guitarra');
    });
  });
}
