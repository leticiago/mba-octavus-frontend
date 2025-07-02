import 'package:flutter/material.dart';

class AtividadeTextoScreen extends StatelessWidget {
  final String activityId;
  const AtividadeTextoScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resposta Livre')),
      body: Center(child: Text('Tela de resposta livre: $activityId')),
    );
  }
}
