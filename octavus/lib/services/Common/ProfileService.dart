import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/profile_model.dart';

class ProfileService {
  final String baseUrl = 'http://10.0.2.2:5277';

  Future<List<Profile>> getProfiles() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/profiles'));
    if (response.statusCode == 200) {
      final List list = jsonDecode(response.body);
      return list.map((e) => Profile.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar perfis');
    }
  }
}
