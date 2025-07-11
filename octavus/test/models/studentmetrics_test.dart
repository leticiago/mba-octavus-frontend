import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/StudentMetrics.dart';

void main() {
  group('StudentMetrics', () {
    test('Deve criar um objeto com valores corretos via construtor', () {
      final metrics = StudentMetrics(
        totalActivitiesDone: 10,
        averageScore: 85.5,
        averageScoreByActivityType: {
          'quiz': 90.0,
          'assignment': 80.0,
        },
      );

      expect(metrics.totalActivitiesDone, 10);
      expect(metrics.averageScore, 85.5);
      expect(metrics.averageScoreByActivityType.length, 2);
      expect(metrics.averageScoreByActivityType['quiz'], 90.0);
      expect(metrics.averageScoreByActivityType['assignment'], 80.0);
    });

    test('Deve criar um objeto a partir do JSON corretamente', () {
      final json = {
        'totalActivitiesDone': 5,
        'averageScore': 78.25,
        'averageScoreByActivityType': {
          'quiz': 80,
          'assignment': 76.5,
        },
      };

      final metrics = StudentMetrics.fromJson(json);

      expect(metrics.totalActivitiesDone, 5);
      expect(metrics.averageScore, 78.25);
      expect(metrics.averageScoreByActivityType.length, 2);
      expect(metrics.averageScoreByActivityType['quiz'], 80.0);
      expect(metrics.averageScoreByActivityType['assignment'], 76.5);
    });

    test('Deve lançar erro se o JSON for inválido ou campos ausentes', () {
      final jsonInvalido = {
        'averageScore': 70.0,
        'averageScoreByActivityType': {
          'quiz': 70.0,
        },
      };

      // Como o factory espera totalActivitiesDone, ao não ter, deve lançar erro
      expect(() => StudentMetrics.fromJson(jsonInvalido), throwsA(isA<TypeError>()));
    });
  });
}
