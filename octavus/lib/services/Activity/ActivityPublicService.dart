import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/activity_model.dart';
import '../auth/tokenservice.dart';

class ActivityPublicService {
  final String baseUrl;

  ActivityPublicService({String? baseUrl})
      : baseUrl = baseUrl ?? 'http://10.0.2.2:5277/api';

  Future<List<Activity>> fetchPublicActivities() async {
    final token = await TokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/activity/public');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Activity.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar atividades públicas: ${response.statusCode} - ${response.body}');
    }
  }
}
