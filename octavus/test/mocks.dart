import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:octavus/services/auth/interfaces/i_token_service.dart';
import 'package:octavus/services/auth/authentication_service.dart';

@GenerateMocks([http.Client, ITokenService, AuthService])
void main() {}
