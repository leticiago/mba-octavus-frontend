import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/studentmodel.dart'; 
import '../models/studentprofessormodel.dart';
import '../services/tokenservice.dart';  
import '../models/pendingreviewmodel.dart';
import '../models/activitymodel.dart';


class ProfessorService {
  final String baseUrl;

  ProfessorService({required this.baseUrl});

  Future<List<Student>> getStudentsByProfessor(String professorId) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/professor/$professorId/students');
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

    final url = Uri.parse('$baseUrl/api/professor/link-student');
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

    final url = Uri.parse('$baseUrl/api/Professor/$professorId/pending-reviews');
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

  Future<void> createActivity(Activity activity) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/api/activity');
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
  }
}
