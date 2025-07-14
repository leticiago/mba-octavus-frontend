import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/pending_review_model.dart';

void main() {
  group('PendingReview', () {
    test('Deve instanciar corretamente via construtor', () {
      final review = PendingReview(
        activity: 'Atividade 1',
        activityId: 'a123',
        student: 'Maria',
        studentId: 's456',
      );

      expect(review.activity, 'Atividade 1');
      expect(review.activityId, 'a123');
      expect(review.student, 'Maria');
      expect(review.studentId, 's456');
    });

    test('fromJson deve converter corretamente o JSON completo', () {
      final Map<String, dynamic> json = {
        'activityName': 'Atividade 2',
        'activityId': 'a789',
        'studentName': 'João',
        'studentId': 's321',
      };

      final review = PendingReview.fromJson(json);

      expect(review.activity, 'Atividade 2');
      expect(review.activityId, 'a789');
      expect(review.student, 'João');
      expect(review.studentId, 's321');
    });

    test('fromJson deve preencher valores padrões quando campos estiverem ausentes', () {
      final Map<String, dynamic> json = {};

      final review = PendingReview.fromJson(json);

      expect(review.activity, '');
      expect(review.activityId, '');
      expect(review.student, '');
      expect(review.studentId, '');
    });
  });
}
