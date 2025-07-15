import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:octavus/services/Auth/Interfaces/ITokenService.dart';
import '../../models/activity_model.dart';

class ActivityPublicService {
  final String baseUrl;
  final http.Client client;
  final ITokenService tokenService;

  ActivityPublicService({
    required this.tokenService,
    String? baseUrl,
    http.Client? client,
  })  : baseUrl = baseUrl ?? 'http://10.0.2.2:5277/api',
        client = client ?? http.Client();

  Future<List<Activity>> fetchPublicActivities() async {
    final token = await tokenService.getToken();
    if (token == null) {
      throw Exception('Token de autenticação não encontrado');
    }

    final url = Uri.parse('$baseUrl/activity/public');
    final response = await client.get(
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
