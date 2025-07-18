import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octavus/views/Common/metronome_screen.dart';

void main() {
  testWidgets('Deve renderizar os elementos principais', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MetronomeScreen()));

    expect(find.text('Metrônomo'), findsOneWidget);

    expect(find.text('Ajuste o BPM:'), findsOneWidget);

    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('120 BPM'), findsOneWidget);

    expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
  });

  testWidgets('Deve alterar o BPM ao mover o slider', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MetronomeScreen()));

    final slider = find.byType(Slider);
    await tester.drag(slider, const Offset(-100, 0));
    await tester.pump();

    expect(find.text('120 BPM'), findsNothing); 
  });

  testWidgets('Deve alternar ícone de play/pause ao clicar no botão', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: MetronomeScreen()));

    final playIcon = find.byIcon(Icons.play_circle_fill);
    expect(playIcon, findsOneWidget);

    await tester.tap(playIcon);
    await tester.pump();

    expect(find.byIcon(Icons.pause_circle_filled), findsOneWidget);

    await tester.tap(find.byIcon(Icons.pause_circle_filled));
    await tester.pump();

    expect(find.byIcon(Icons.play_circle_fill), findsOneWidget);
  });
}
