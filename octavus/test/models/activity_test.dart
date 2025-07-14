import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/activity_model.dart';

void main() {
  group('Activity', () {
    test('fromJson deve criar instância corretamente', () {
      final json = {
        'id': 'abc123',
        'name': 'Escala Maior',
        'description': 'Exercício de escalas',
        'type': 1,
        'date': '2025-07-10T00:00:00.000',
        'level': 2,
        'isPublic': true,
        'instrumentId': 'inst001',
        'professorId': 'prof001',
      };

      final activity = Activity.fromJson(json);

      expect(activity.id, 'abc123');
      expect(activity.name, 'Escala Maior');
      expect(activity.description, 'Exercício de escalas');
      expect(activity.type, 1);
      expect(activity.date, DateTime.parse('2025-07-10T00:00:00.000'));
      expect(activity.level, 2);
      expect(activity.isPublic, true);
      expect(activity.instrumentId, 'inst001');
      expect(activity.professorId, 'prof001');
    });

    test('toJson deve converter instância corretamente', () {
      final activity = Activity(
        id: 'abc123',
        name: 'Arpejos',
        description: 'Atividade de arpejos',
        type: 2,
        date: DateTime.parse('2025-07-11T10:30:00.000'),
        level: 3,
        isPublic: false,
        instrumentId: 'inst002',
        professorId: 'prof002',
      );

      final json = activity.toJson();

      expect(json['name'], 'Arpejos');
      expect(json['description'], 'Atividade de arpejos');
      expect(json['type'], 2);
      expect(json['date'], '2025-07-11T10:30:00.000');
      expect(json['level'], 3);
      expect(json['isPublic'], false);
      expect(json['instrumentId'], 'inst002');
      expect(json['professorId'], 'prof002');
      expect(json.containsKey('id'), isFalse); 
    });

    test('fromJson deve aceitar professorId nulo', () {
      final json = {
        'id': 'xyz789',
        'name': 'Improvisação',
        'description': 'Improviso com pentatônica',
        'type': 0,
        'date': '2025-07-12T12:00:00.000',
        'level': 1,
        'isPublic': true,
        'instrumentId': 'inst003',
        'professorId': null,
      };

      final activity = Activity.fromJson(json);

      expect(activity.professorId, isNull);
    });
  });
}
