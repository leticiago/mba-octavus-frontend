import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/forms/question_form_data.dart';
import 'tokenservice.dart';

class QuestionService {
  final String baseUrl = 'http://10.0.2.2:5277';

  QuestionService();

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

  Future<bool> postDragAndDropActivity({
    required String activityId,
    required String originalSequence,
  }) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/draganddrop');

    final body = jsonEncode({
      'activityId': activityId,
      'originalSequence': originalSequence,
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

  Future<bool> postFreeTextActivity({
    required String activityId,
    required String title,
  }) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/OpenText/question');

    final body = jsonEncode({
      'activityId': activityId,
      'title': title,
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
