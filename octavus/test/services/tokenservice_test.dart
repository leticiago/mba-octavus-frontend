import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:octavus/services/auth/token_service.dart';
import 'dart:convert';

void main() {
  late TokenService tokenService;

  setUp(() {
    tokenService = TokenService();
  });

  group('TokenService', () {
    test('saveToken e getToken armazenam e recuperam token corretamente', () async {
      SharedPreferences.setMockInitialValues({}); 

      const token = 'meu.token.exemplo';

      await tokenService.saveToken(token);
      final storedToken = await tokenService.getToken();

      expect(storedToken, token);
    });

    test('removeToken remove o token armazenado', () async {
      SharedPreferences.setMockInitialValues({'auth_token': 'token_para_remover'});

      var storedToken = await tokenService.getToken();
      expect(storedToken, isNotNull);

      await tokenService.removeToken();

      storedToken = await tokenService.getToken();
      expect(storedToken, isNull);
    });

    group('extractEmailFromToken', () {
      test('retorna email extraído corretamente', () {
        const payload = '{"email":"teste@octavus.com"}';
        final payloadBase64 = base64Url.encode(utf8.encode(payload)).replaceAll('=', '');
        final fakeToken = 'header.$payloadBase64.signature';

        final email = tokenService.extractEmailFromToken(fakeToken);

        expect(email, 'teste@octavus.com');
      });

      test('retorna null para token mal formatado', () {
        final email = tokenService.extractEmailFromToken('token_invalido');
        expect(email, isNull);
      });

      test('retorna null para token com payload inválido', () {
        final invalidPayload = base64Url.encode(utf8.encode('texto_invalido')).replaceAll('=', '');
        final fakeToken = 'header.$invalidPayload.signature';

        expect(() => tokenService.extractEmailFromToken(fakeToken), throwsA(isA<FormatException>()));
      });
    });

    group('extractNameFromToken', () {
      test('retorna name extraído corretamente', () {
        const payload = '{"name":"Leticia"}';
        final payloadBase64 = base64Url.encode(utf8.encode(payload)).replaceAll('=', '');
        final fakeToken = 'header.$payloadBase64.signature';

        final name = tokenService.extractNameFromToken(fakeToken);

        expect(name, 'Leticia');
      });

      test('retorna null para token mal formatado', () {
        final name = tokenService.extractNameFromToken('token_invalido');
        expect(name, isNull);
      });

      test('retorna null para token com payload inválido', () {
        final invalidPayload = base64Url.encode(utf8.encode('texto_invalido')).replaceAll('=', '');
        final fakeToken = 'header.$invalidPayload.signature';

        expect(() => tokenService.extractNameFromToken(fakeToken), throwsA(isA<FormatException>()));
      });
    });
  });
}
