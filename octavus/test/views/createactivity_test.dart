import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/views/Activity/Professor/create_activity_screen.dart';

void main() {
  group('CreateActivityScreen Tests', () {
    testWidgets('Renderiza os campos esperados', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CreateActivityScreen(
            onNavigateWithId: (index, id) {},
          ),
        ),
      );

      expect(find.text('Cadastre uma atividade'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<int>), findsNWidgets(2)); // Tipo e Dificuldade
      expect(find.byType(TextFormField), findsNWidgets(2)); // Título e Descrição
      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Mostra SnackBar se campos não preenchidos', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateActivityScreen(
              onNavigateWithId: (index, id) {},
            ),
          ),
        ),
      );

      // Espera carregar
      await tester.pumpAndSettle();

      // Toca no botão de avançar
      final advanceButton = find.widgetWithText(ElevatedButton, 'Avançar >');
      await tester.tap(advanceButton);
      await tester.pump(); // pump para mostrar snackbar

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Preencha todos os campos'), findsOneWidget);
    });
  });
}
