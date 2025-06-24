import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forms/question_form_data.dart';
import 'tokenservice.dart';

class QuestionService {
  final String baseUrl;

  QuestionService({required this.baseUrl});

  Future<bool> postQuestions({
    required String activityId,
    required List<QuestionFormData> questions,
  }) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/question');

    final List<Map<String, dynamic>> formattedQuestions = questions.map((q) {
    return {
        'title': q.titleController.text,
        'answers': List.generate(q.answers.length, (i) {
        return {
            'text': q.answers[i].textController.text,
            'isCorrect': q.answers[i].isCorrect,
        };
        }),
    };
    }).toList();

    final body = jsonEncode({
      'activityId': activityId,
      'questions': formattedQuestions,
    });

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
