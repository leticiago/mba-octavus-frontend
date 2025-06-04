import 'package:jwt_decoder/jwt_decoder.dart';

String? getRoleFromToken(String token) {
  final decodedToken = JwtDecoder.decode(token);
  final roles = decodedToken['realm_access']?['roles'] as List<dynamic>?;

  if (roles == null) return null;

  if (roles.contains('Aluno')) return 'Aluno';
  if (roles.contains('Professor')) return 'Professor';
  if (roles.contains('Colaborador')) return 'Colaborador';

  return null;
}
