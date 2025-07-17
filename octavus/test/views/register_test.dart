import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/views/Login/register_screen.dart';

void main() {
  testWidgets('Renderiza todos os campos do formulário de cadastro', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.pumpAndSettle();

    expect(find.text("Criar uma conta"), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(5));
    expect(find.text("Próximo"), findsOneWidget);
    expect(find.text("Já possui uma conta? Entrar"), findsOneWidget);
  });

  testWidgets('Mostra erro se campos obrigatórios não forem preenchidos', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.tap(find.text("Próximo"));
    await tester.pump(); 

    expect(find.text("Campo obrigatório"), findsWidgets);
  });

  testWidgets('Valida email inválido', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    await tester.enterText(find.byType(TextFormField).at(3), "email_invalido");
    await tester.tap(find.text("Próximo"));
    await tester.pump();

    expect(find.text("Digite um e-mail válido"), findsOneWidget);
  });

  testWidgets('Valida senha com menos de 6 caracteres', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));

    await tester.enterText(find.byType(TextFormField).at(4), "123");
    await tester.tap(find.text("Próximo"));
    await tester.pump();

    expect(find.text("A senha deve ter pelo menos 6 caracteres"), findsOneWidget);
  });

  testWidgets('Navega para próxima tela ao preencher corretamente', (WidgetTester tester) async {
    final navigatorObserver = _MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
      home: const RegisterScreen(),
      navigatorObservers: [navigatorObserver],
      routes: {
        '/profile': (context) => const Scaffold(body: Text("Perfil")),
      },
    ));

    await tester.enterText(find.byType(TextFormField).at(0), "João");
    await tester.enterText(find.byType(TextFormField).at(1), "Silva");
    await tester.enterText(find.byType(TextFormField).at(2), "joaosilva");
    await tester.enterText(find.byType(TextFormField).at(3), "joao@email.com");
    await tester.enterText(find.byType(TextFormField).at(4), "123456");

    await tester.tap(find.text("Próximo"));
    await tester.pumpAndSettle();

    expect(find.text("Perfil"), findsOneWidget);
  });
}

class _MockNavigatorObserver extends NavigatorObserver {
  final List<Route> _routes = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    _routes.add(route);
    super.didPush(route, previousRoute);
  }

  List<Route> get routes => _routes;
}
