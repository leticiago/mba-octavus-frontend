import 'package:flutter/material.dart';

class AtividadeDragDropScreen extends StatelessWidget {
  final String activityId;
  const AtividadeDragDropScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drag and Drop')),
      body: Center(child: Text('Tela drag and drop: $activityId')),
    );
  }
}
