import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/login_model.dart';

void main() {
  group('User', () {
    test('Deve criar uma instância corretamente', () {
      final user = User(username: 'leticia', password: '123456');

      expect(user.username, 'leticia');
      expect(user.password, '123456');
    });

    test('toJson deve converter objeto User em JSON corretamente', () {
      final user = User(username: 'joao', password: 'senhaSegura');

      final json = user.toJson();

      expect(json['username'], 'joao');
      expect(json['password'], 'senhaSegura');
    });
  });
}
