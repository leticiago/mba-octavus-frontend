import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/open_text_answer_model.dart';

void main() {
  group('OpenTextAnswer', () {
    test('Deve criar uma instância corretamente', () {
      final now = DateTime.now();
      final answer = OpenTextAnswer(
        questionId: 'q1',
        studentId: 's1',
        responseText: 'Minha resposta',
        submittedAt: now,
      );

      expect(answer.questionId, 'q1');
      expect(answer.studentId, 's1');
      expect(answer.responseText, 'Minha resposta');
      expect(answer.submittedAt, now);
    });

    test('fromJson deve converter um JSON em OpenTextAnswer corretamente', () {
      final json = {
        'questionId': 'q123',
        'studentId': 's456',
        'responseText': 'Resposta aberta',
        'submittedAt': '2025-07-11T12:00:00.000Z',
      };

      final answer = OpenTextAnswer.fromJson(json);

      expect(answer.questionId, 'q123');
      expect(answer.studentId, 's456');
      expect(answer.responseText, 'Resposta aberta');
      expect(answer.submittedAt, DateTime.parse('2025-07-11T12:00:00.000Z'));
    });
  });
}
