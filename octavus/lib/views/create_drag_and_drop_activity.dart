import 'package:flutter/material.dart';
import '../services/questionservice.dart'; // importe seu service

class CreateDragAndDropActivityScreen extends StatefulWidget {
  final String activityId;

  const CreateDragAndDropActivityScreen({
    super.key,
    required this.activityId,
  });

  @override
  State<CreateDragAndDropActivityScreen> createState() =>
      _CreateDragAndDropActivityScreenState();
}

class _CreateDragAndDropActivityScreenState
    extends State<CreateDragAndDropActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _instructionController = TextEditingController();
  final TextEditingController _optionsController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _instructionController.dispose();
    _optionsController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final service = QuestionService();

    try {
      final success = await service.postDragAndDropActivity(
        activityId: widget.activityId,
        originalSequence: _optionsController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Atividade enviada com sucesso!' : 'Erro ao enviar atividade.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        Navigator.pop(context); // Volta para a tela anterior após sucesso
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('Criar Atividade: Arrasta e Solta'),
        backgroundColor: const Color(0xFFFFD965),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Instruções',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _instructionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Digite a instrução da atividade',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Opções (separadas por ponto e vírgula)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _optionsController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ex: opção 1; opção 2; opção 3',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD965),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'Salvar atividade',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
