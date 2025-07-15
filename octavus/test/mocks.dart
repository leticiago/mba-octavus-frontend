import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:octavus/services/Auth/Interfaces/ITokenService.dart';

@GenerateMocks([http.Client, ITokenService])
void main() {}
