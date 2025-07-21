import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/views/Common/tutorial_screen.dart';
import 'package:octavus/views/Login/welcome_screen.dart';

void main() {
  testWidgets('TutorialScreen inicia na primeira página com título correto', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: TutorialScreen()),
    );

    expect(find.text('Pratique de onde estiver'), findsOneWidget);
    expect(find.textContaining('Tenha acesso aos exercícios'), findsOneWidget);

    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);
  });

  testWidgets('Troca de página atualiza título e descrição', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: TutorialScreen()),
    );

    await tester.drag(find.byType(PageView), const Offset(-400.0, 0));
    await tester.pumpAndSettle();

    expect(find.text('Se conecte com seus alunos'), findsOneWidget);
    expect(find.textContaining('Envie atividades'), findsOneWidget);

    await tester.drag(find.byType(PageView), const Offset(-400.0, 0));
    await tester.pumpAndSettle();

    expect(find.textContaining('Não pode corrigir atividades?'), findsOneWidget);
  });

  testWidgets('Botão next avança páginas e navega para WelcomeScreen na última página', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: TutorialScreen()),
    );

    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pumpAndSettle();

    expect(find.text('Se conecte com seus alunos'), findsOneWidget);


    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pumpAndSettle();

    expect(find.textContaining('Não pode corrigir atividades?'), findsOneWidget);


    await tester.tap(find.byIcon(Icons.arrow_forward_ios));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.textContaining(''), findsOneWidget);
  });
}
