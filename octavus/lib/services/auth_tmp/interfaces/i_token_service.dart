abstract class ITokenService {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  Future<void> removeToken();
  String? extractEmailFromToken(String token);
  String? extractNameFromToken(String token);
}
