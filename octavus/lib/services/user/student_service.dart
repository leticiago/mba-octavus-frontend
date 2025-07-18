import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:octavus/models/dtos/activitystudent.dart';
import 'package:octavus/models/dtos/studentcompletedactivity.dart';
import '../../models/student_metrics_model.dart';
import '../auth/token_service.dart';
import '../../models/open_text_answer_model.dart';
import 'package:uuid/uuid.dart';

class StudentService {
  final String baseUrl;
  final TokenService _tokenService;
  final http.Client _client;

  StudentService({
    String? baseUrl,
    required TokenService tokenService,
    http.Client? client, 
  })  : baseUrl = baseUrl ?? 'http://10.0.2.2:5277/api',
        _tokenService = tokenService,
        _client = client ?? http.Client(); 

  Future<List<StudentCompletedActivity>> getCompletedActivities(String studentId) async {
    final token = await _tokenService.getToken(); 
    if (token == null) throw Exception('Token de autenticação não encontrado');

    final url = Uri.parse('$baseUrl/student/$studentId/completed-activities');
    final response = await _client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => StudentCompletedActivity.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar atividades concluídas: ${response.statusCode}');
    }
  }

  Future<List<ActivityStudent>> getActivities(String studentId) async {
    final token = await _tokenService.getToken(); 
    if (token == null) throw Exception('Token de autenticação não encontrado');

    final url = Uri.parse('$baseUrl/student/$studentId/activities');
    final response = await _client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ActivityStudent.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar atividades: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> submitQuestionAndAnswer({
    required String activityId,
    required String studentId,
    required List<Map<String, String>> answers,
  }) async {
    final token = await _tokenService.getToken(); 
    if (token == null) throw Exception('Token não encontrado');

    final url = Uri.parse('$baseUrl/student/submit/question-and-answer');

    final body = jsonEncode({
      "activityId": activityId,
      "studentId": studentId,
      "answers": answers,
    });

    final response = await _client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> submitDragAndDropAnswer({
    required String activityId,
    required String studentId,
    required List<String> orderedOptions,
  }) async {
    final token = await _tokenService.getToken();
    if (token == null) throw Exception('Token de autenticação não encontrado');

    final url = Uri.parse('$baseUrl/student/submit/drag-and-drop');

    final body = jsonEncode({
      'activityId': activityId,
      'studentId': studentId,
      'answer': orderedOptions.join(';'),
    });

    final response = await _client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }

  Future<bool> submitOpenTextAnswer({
    required String questionId,
    required String studentId,
    required String responseText,
  }) async {
    final token = await _tokenService.getToken();
    if (token == null) throw Exception('Token de autenticação não encontrado');

    final url = Uri.parse('$baseUrl/opentext/answer');
    final uuid = const Uuid().v4();

    final body = jsonEncode({
      "id": uuid,
      "questionId": questionId,
      "studentId": studentId,
      "responseText": responseText,
      "submittedAt": DateTime.now().toIso8601String(),
    });

    final response = await _client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Erro ao enviar resposta: ${response.statusCode} - ${response.body}');
    }
  }

  Future<OpenTextAnswer?> getOpenTextAnswer({
    required String activityId,
    required String studentId,
  }) async {
    final token = await _tokenService.getToken();
    if (token == null) throw Exception('Token de autenticação não encontrado');

    final url = Uri.parse('$baseUrl/opentext/activity/$activityId/student/$studentId');

    final response = await _client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      return OpenTextAnswer.fromJson(jsonMap);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Erro ao buscar resposta: ${response.statusCode} - ${response.body}');
    }
  }

  Future<StudentMetrics> getStudentMetrics(String studentId) async {
    final token = await _tokenService.getToken(); 
    if (token == null) throw Exception('Token de autenticação não encontrado');

    final url = Uri.parse('$baseUrl/student/$studentId/metrics');

    final response = await _client.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return StudentMetrics.fromJson(data);
    } else {
      throw Exception('Erro ao buscar métricas: ${response.statusCode} - ${response.body}');
    }
  }
}
