import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/tokenservice.dart';
import '../models/dtos/studentcompletedactivity.dart';
import '../models/dtos/activitystudent.dart';

class StudentService {
  final String baseUrl;

  StudentService({String? baseUrl})
      : baseUrl = baseUrl ?? 'http://10.0.2.2:5277/api';

  Future<List<StudentCompletedActivity>> getCompletedActivities(String studentId) async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/student/$studentId/completed-activities');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => StudentCompletedActivity.fromJson(json))
          .toList();
    } else {
      throw Exception('Falha ao carregar atividades concluídas: ${response.statusCode}');
    }
  }

  Future<List<ActivityStudent>> getActivities(String studentId) async {
    final token = await TokenService.getToken();
    if (token == null) throw Exception('Token de autenticação não encontrado');

    final url = Uri.parse('$baseUrl/student/$studentId/activities');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => ActivityStudent.fromJson(json))
          .toList();
    } else {
      throw Exception('Falha ao carregar atividades: ${response.statusCode}');
    }
  }
}
