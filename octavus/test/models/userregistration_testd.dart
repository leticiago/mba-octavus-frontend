import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/models/userregistrationmodel.dart';

void main() {
  group('UserRegistration', () {
    test('Deve criar um objeto com os valores corretos', () {
      final user = UserRegistration(
        name: 'Maria',
        surname: 'Silva',
        email: 'maria@example.com',
        password: '123456',
        username: 'mariasilva',
        contact: '99999-9999',
        instrumentId: 'instr01',
        profileId: 'profile01',
        roles: ['admin', 'user'],
      );

      expect(user.name, 'Maria');
      expect(user.surname, 'Silva');
      expect(user.email, 'maria@example.com');
      expect(user.password, '123456');
      expect(user.username, 'mariasilva');
      expect(user.contact, '99999-9999');
      expect(user.instrumentId, 'instr01');
      expect(user.profileId, 'profile01');
      expect(user.roles, isNotNull);
      expect(user.roles!.length, 2);
    });

    test('Deve converter para JSON corretamente', () {
      final user = UserRegistration(
        name: 'João',
        surname: 'Pereira',
        email: 'joao@example.com',
        password: 'abcdef',
        username: 'joaop',
        contact: '88888-8888',
        instrumentId: 'instr02',
        profileId: 'profile02',
        roles: ['user'],
      );

      final json = user.toJson();

      expect(json['name'], 'João');
      expect(json['surname'], 'Pereira');
      expect(json['email'], 'joao@example.com');
      expect(json['password'], 'abcdef');
      expect(json['username'], 'joaop');
      expect(json['contact'], '88888-8888');
      expect(json['instrumentId'], 'instr02');
      expect(json['profileId'], 'profile02');
      expect(json['roles'], ['user']);
    });

    test('Deve serializar com roles nulo', () {
      final user = UserRegistration(
        name: 'Ana',
        surname: 'Souza',
        email: 'ana@example.com',
        password: 'senha123',
        username: 'anas',
        contact: '77777-7777',
        instrumentId: 'instr03',
        profileId: 'profile03',
        roles: null,
      );

      final json = user.toJson();

      expect(json['roles'], null);
    });
  });
}
