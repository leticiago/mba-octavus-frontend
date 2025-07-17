import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/views/Login/login_screen.dart'; // atualize conforme o caminho real

void main() {
  testWidgets('LoginScreen deve mostrar botão de Entrar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('LoginScreen mostra mensagem de erro se login falhar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Simular clique no botão
    await tester.tap(find.text('Entrar'));
    await tester.pump(); // dispara o SnackBar

    // Verifica se apareceu alguma mensagem de erro
    expect(find.textContaining('Falha no login'), findsOneWidget);
  });
}
