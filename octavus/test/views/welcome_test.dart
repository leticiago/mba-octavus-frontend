import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/services/auth/token_service.dart';
import 'package:octavus/views/Login/welcome_screen.dart';

void main() {
  testWidgets('Exibe mensagem de boas-vindas e botão de navegação', (tester) async {
    const userName = 'Letícia';

    final tokenService = TokenService();

    await tester.pumpWidget(
      MaterialApp(
        home: WelcomeScreen(
          userName: userName,
          tokenService: tokenService,
        ),
        routes: {
          '/home': (context) => const Scaffold(body: Text('Home Screen')),
        },
      ),
    );

    expect(find.text('Bem vindo, $userName'), findsOneWidget);
    expect(find.text('Tudo certo agora, vamos estudar!'), findsOneWidget);

    final buttonFinder = find.widgetWithText(ElevatedButton, 'Ir para a home');
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Home Screen'), findsOneWidget);
  });
}
