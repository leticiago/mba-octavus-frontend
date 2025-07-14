import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/instrument_model.dart';

class InstrumentService {
  final String baseUrl = 'http://10.0.2.2:5277';

  Future<List<Instrument>> getInstruments() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/instruments'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Instrument.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar instrumentos');
    }
  }
}
