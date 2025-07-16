
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:octavus/models/forms/answer_form_data.dart';
import 'package:octavus/models/forms/question_form_data.dart';
import 'package:octavus/services/activity/question_service.dart';

import '../mocks.mocks.dart';


void main() {
  late MockClient mockClient;
  late MockITokenService mockTokenService;
  late QuestionService service;

  setUp(() {
    mockClient = MockClient();
    mockTokenService = MockITokenService();
    service = QuestionService(
      client: mockClient,
      tokenService: mockTokenService,
    );
  });

  test('postQuestions deve retornar true com status 201', () async {
    final uri = Uri.parse('http://10.0.2.2:5277/api/question');

    final form = QuestionFormData(
      questionTitle: 'Pergunta 1',
      answers: [
        AnswerFormData(text: 'Resposta A', isCorrect: true),
        AnswerFormData(text: 'Resposta B', isCorrect: false),
      ],
    );

    when(mockTokenService.getToken()).thenAnswer((_) async => 'fake-token');

    when(mockClient.post(
      uri,
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('', 201));

    final result = await service.postQuestions(
      activityId: '123',
      questions: [form],
    );

    expect(result, isTrue);
  });

  test('postDragAndDropActivity deve retornar true com status 200', () async {
    final uri = Uri.parse('http://10.0.2.2:5277/api/draganddrop');

    when(mockTokenService.getToken()).thenAnswer((_) async => 'fake-token');

    when(mockClient.post(
      uri,
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('', 200));

    final result = await service.postDragAndDropActivity(
      activityId: 'abc',
      originalSequence: 'a;b;c',
    );

    expect(result, isTrue);
  });

  test('postFreeTextActivity deve retornar false com status 400', () async {
    final uri = Uri.parse('http://10.0.2.2:5277/api/OpenText/question');

    when(mockTokenService.getToken()).thenAnswer((_) async => 'fake-token');

    when(mockClient.post(
      uri,
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Erro', 400));

    final result = await service.postFreeTextActivity(
      activityId: 'abc',
      title: 'Questão discursiva',
    );

    expect(result, isFalse);
  });

  test('getQuestionsByActivityId deve lançar exceção se JSON inválido', () async {
    final uri = Uri.parse('http://10.0.2.2:5277/api/question/activity/999');

    when(mockTokenService.getToken()).thenAnswer((_) async => 'fake-token');

    when(mockClient.get(
      uri,
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('{"not": "a list"}', 200));

    expect(
      () async => await service.getQuestionsByActivityId('999'),
      throwsException,
    );
  });
}
