import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/forms/question_form_data.dart';
import '../../models/open_text_question_model.dart';
import 'package:octavus/services/auth/interfaces/i_token_service.dart';

class QuestionService {
  final String baseUrl;
  final http.Client client;
  final ITokenService tokenService;

  QuestionService({
    required this.tokenService,
    this.baseUrl = 'http://10.0.2.2:5277',
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<bool> postQuestions({
    required String activityId,
    required List<QuestionFormData> questions,
  }) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/question');

    final List<Map<String, dynamic>> formattedQuestions = questions.map((q) {
      return {
        'title': q.titleController.text,
        'answers': q.answers.map((a) {
          return {
            'text': a.textController.text,
            'isCorrect': a.isCorrect,
          };
        }).toList(),
      };
    }).toList();

    final body = jsonEncode({
      'activityId': activityId,
      'questions': formattedQuestions,
    });

    final response = await client.post(
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
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/draganddrop');

    final body = jsonEncode({
      'activityId': activityId,
      'originalSequence': originalSequence,
    });

    final response = await client.post(
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
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/OpenText/question');

    final body = jsonEncode({
      'activityId': activityId,
      'title': title,
    });

    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<dynamic>> getQuestionsByActivityId(String activityId) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/question/activity/$activityId');

    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded;
        } else {
          throw Exception('Resposta inesperada: não é uma lista');
        }
      } catch (e) {
        throw Exception('Erro ao fazer parsing da resposta: $e');
      }
    } else {
      throw Exception('Erro ao buscar perguntas da atividade: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getDragAndDropOptions(String activityId) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/draganddrop/$activityId');

    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar opções de drag and drop');
    }
  }

  Future<OpenTextQuestionModel> getOpenTextActivity(String activityId) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/opentext/question/$activityId');

    final response = await client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return OpenTextQuestionModel.fromJson(data.first);
      } else {
        throw Exception('Nenhuma pergunta encontrada.');
      }
    } else {
      throw Exception('Erro ao buscar atividade: ${response.statusCode}');
    }
  }
}
