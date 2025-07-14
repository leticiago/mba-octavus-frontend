import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/student_model.dart';

void main() {
  group('Student', () {
    test('Deve criar um objeto Student pelo construtor', () {
      final student = Student(id: '123', name: 'Maria');

      expect(student.id, '123');
      expect(student.name, 'Maria');
    });

    test('Deve criar um objeto Student a partir do JSON', () {
      final json = {'id': '456', 'name': 'João'};
      final student = Student.fromJson(json);

      expect(student.id, '456');
      expect(student.name, 'João');
    });

    test('Deve lançar erro ao criar a partir de JSON inválido', () {
      final jsonInvalido = {'id': 123}; // falta campo name e id não é string

      expect(() => Student.fromJson(jsonInvalido), throwsA(isA<TypeError>()));
    });
  });
}
