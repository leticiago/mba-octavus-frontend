import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/open_text_question_model.dart';

void main() {
  group('OpenTextQuestionModel', () {
    test('Deve criar uma instância corretamente', () {
      final model = OpenTextQuestionModel(
        id: 'q1',
        title: 'O que é Flutter?',
        answers: ['Resposta 1', 'Resposta 2'],
      );

      expect(model.id, 'q1');
      expect(model.title, 'O que é Flutter?');
      expect(model.answers, isA<List<dynamic>>());
      expect(model.answers.length, 2);
    });

    test('fromJson deve converter JSON corretamente', () {
      final json = {
        'id': 'q123',
        'title': 'Explique o conceito de widget',
        'answers': ['Resposta A', 'Resposta B'],
      };

      final model = OpenTextQuestionModel.fromJson(json);

      expect(model.id, 'q123');
      expect(model.title, 'Explique o conceito de widget');
      expect(model.answers.length, 2);
    });

    test('fromJson deve tratar ausência de answers como lista vazia', () {
      final json = {
        'id': 'q456',
        'title': 'Sem respostas ainda',
      };

      final model = OpenTextQuestionModel.fromJson(json);

      expect(model.id, 'q456');
      expect(model.title, 'Sem respostas ainda');
      expect(model.answers, isEmpty);
    });
  });
}
