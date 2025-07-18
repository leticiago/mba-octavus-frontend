import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/views/Common/initial_screen.dart';

void main() {
  testWidgets('Deve renderizar o logo, título e botão "Começar"', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: InitialScreen(),
      ),
    );

    expect(find.byType(Image), findsOneWidget);

    expect(find.text('OCT'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.text('VUS'), findsOneWidget);
    expect(find.text('MUSIC THEORY TEACHING APP'), findsOneWidget);

    expect(find.text('Começar'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Deve navegar para a rota /login ao clicar no botão', (WidgetTester tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        routes: {
          '/': (_) => const InitialScreen(),
          '/login': (_) => const Scaffold(body: Text('Login Screen')),
        },
      ),
    );

    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();

    expect(find.text('Login Screen'), findsOneWidget);
  });
}
