import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/studentmodel.dart'; 
import '../models/studentprofessormodel.dart';
import '../services/tokenservice.dart';  
import '../models/pendingreviewmodel.dart';
import '../models/activitymodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dtos/assignactivityrequest.dart';


class ProfessorService {
  final String baseUrl;

  ProfessorService({String? baseUrl})
      : baseUrl = baseUrl ?? 'http://10.0.2.2:5277/api';

  Future<List<Student>> getStudentsByProfessor(String professorId) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/professor/$professorId/students');
    final response = await http.get(url, headers: {
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
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/professor/link-student');
    final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(link.toJson())
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Falha ao vincular aluno: ${response.statusCode}');
    }
  }

    Future<List<PendingReview>> getPendingReviews(String professorId) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/professor/$professorId/pending-reviews');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PendingReview.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar avaliações pendentes: ${response.statusCode}');
    }
  }

  Future<String> createActivity(Activity activity) async {
  final token = await TokenService.getToken();
  if (token == null) {
    throw Exception('Token de autenticação não encontrado');
  }

  final url = Uri.parse('$baseUrl/activity');
  final response = await http.post(
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
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/activity/professor/$professorId');
    final response = await http.get(url, headers: {
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
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/professor/assign-activity');
    final response = await http.post(
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

}
