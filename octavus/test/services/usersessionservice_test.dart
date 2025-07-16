import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/services/Auth/user_session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('UserSessionService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('saveUserId salva o ID corretamente', () async {
      const userId = '12345';

      await UserSessionService.saveUserId(userId);

      final prefs = await SharedPreferences.getInstance();
      final storedId = prefs.getString('userId');
      expect(storedId, equals(userId));
    });

    test('getUserId retorna o ID salvo', () async {
      const userId = '67890';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);

      final result = await UserSessionService.getUserId();

      expect(result, equals(userId));
    });

    test('getUserId retorna null se não houver ID salvo', () async {
      final result = await UserSessionService.getUserId();
      expect(result, isNull);
    });

    test('clearSession remove o ID salvo', () async {
      const userId = 'abcde';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);

      await UserSessionService.clearSession();

      final storedId = prefs.getString('userId');
      expect(storedId, isNull);
    });
  });
}
