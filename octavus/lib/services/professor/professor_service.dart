import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:octavus/models/dtos/assignactivityrequest.dart';
import '../../models/student_model.dart';
import '../../models/student_professor_model.dart';
import '../auth/token_service.dart';
import '../../models/pending_review_model.dart';
import '../../models/activity_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfessorService {
  final String baseUrl;
  final TokenService tokenService;
  final http.Client client; 

  ProfessorService({
    String? baseUrl,
    required this.tokenService,
    http.Client? client, 
  })  : baseUrl = baseUrl ?? 'http://10.0.2.2:5277/api',
        client = client ?? http.Client();

  Future<List<Student>> getStudentsByProfessor(String professorId) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/professor/$professorId/students');
    final response = await client.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar alunos: ${response.statusCode}');
    }
  }

  Future<void> linkStudent(StudentProfessor link) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/professor/link-student');
    final response = await client.post(url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(link.toJson()));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao vincular aluno: ${response.statusCode}');
    }
  }

  Future<List<PendingReview>> getPendingReviews(String professorId) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/professor/$professorId/pending-reviews');
    final response = await client.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PendingReview.fromJson(json)).toList();
    } else {
      throw Exception(
          'Falha ao carregar avaliações pendentes: ${response.statusCode}');
    }
  }

  Future<String> createActivity(Activity activity) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/activity');
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(activity.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Falha ao criar atividade: ${response.statusCode}');
    }

    final responseData = jsonDecode(response.body);
    final activityId = responseData['id'] as String;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_created_activity_id', activityId);

    return activityId;
  }

  Future<List<Activity>> getActivitiesByProfessor(String professorId) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/activity/professor/$professorId');
    final response = await client.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar atividades: ${response.statusCode}');
    }
  }

  Future<void> assignActivityToStudent(AssignActivityRequest request) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/professor/assign-activity');
    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao vincular atividade: ${response.statusCode}');
    }
  }

  Future<void> evaluateActivity({
    required String studentId,
    required String activityId,
    required int score,
    required String comment,
  }) async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/professor/evaluate-activity');

    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'studentId': studentId,
        'activityId': activityId,
        'score': score,
        'comment': comment,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao avaliar atividade');
    }
  }
}
