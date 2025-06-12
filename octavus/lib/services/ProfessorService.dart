import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/studentmodel.dart'; 
import '../models/studentprofessormodel.dart';

class ProfessorService {
  final String baseUrl;
  final String token;

  ProfessorService({required this.baseUrl, required this.token});

  Future<List<Student>> getStudentsByProfessor(String professorId) async {
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
}
