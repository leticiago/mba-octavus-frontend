import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/profilemodel.dart';

void main() {
  group('Profile', () {
    test('Deve instanciar corretamente via construtor', () {
      final profile = Profile(id: '1', name: 'Aluno');

      expect(profile.id, '1');
      expect(profile.name, 'Aluno');
    });

    test('fromJson deve converter corretamente o JSON', () {
      final json = {
        'id': '2',
        'name': 'Professor',
      };

      final profile = Profile.fromJson(json);

      expect(profile.id, '2');
      expect(profile.name, 'Professor');
    });

    test('fromJson lança erro se faltar campo obrigatório', () {
      final jsonIncompleto = {
        'id': '3',
        // 'name' ausente
      };

      expect(() => Profile.fromJson(jsonIncompleto), throwsA(isA<TypeError>()));
    });
  });
}
