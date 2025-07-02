import 'package:flutter/material.dart';

class AtividadeQuestionarioScreen extends StatelessWidget {
  final String activityId;
  const AtividadeQuestionarioScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Questionário')),
      body: Center(child: Text('Tela de questionário: $activityId')),
    );
  }
}
