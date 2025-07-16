import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/student_professor_model.dart';

void main() {
  group('StudentProfessor', () {
    test('Deve criar um objeto pelo construtor', () {
      final sp = StudentProfessor(
        studentEmail: 'student@example.com',
        professorId: 'prof123',
        instrumentId: 'instr456',
      );

      expect(sp.studentEmail, 'student@example.com');
      expect(sp.professorId, 'prof123');
      expect(sp.instrumentId, 'instr456');
    });

    test('Deve criar um objeto a partir do JSON', () {
      final json = {
        'studentEmail': 'student@example.com',
        'professorId': 'prof123',
        'instrumentId': 'instr456',
      };

      final sp = StudentProfessor.fromJson(json);

      expect(sp.studentEmail, 'student@example.com');
      expect(sp.professorId, 'prof123');
      expect(sp.instrumentId, 'instr456');
    });

    test('Deve converter para JSON corretamente', () {
      final sp = StudentProfessor(
        studentEmail: 'student@example.com',
        professorId: 'prof123',
        instrumentId: 'instr456',
      );

      final json = sp.toJson();

      expect(json['studentEmail'], 'student@example.com');
      expect(json['professorId'], 'prof123');
      expect(json['instrumentId'], 'instr456');
    });

    test('Deve lançar erro se o JSON for inválido', () {
      final jsonInvalido = {
        'studentEmail': 'student@example.com',
        'instrumentId': 'instr456',
      };

      expect(() => StudentProfessor.fromJson(jsonInvalido), throwsA(isA<TypeError>()));
    });
  });
}
