import 'package:flutter/material.dart';
import 'package:octavus/services/activity/question_service.dart';
import 'package:octavus/services/auth/interfaces/i_token_service.dart';

class CreateDragAndDropActivityScreen extends StatefulWidget {
  final String activityId;
  final ITokenService tokenService;
  final void Function(int)? onNavigate;

  const CreateDragAndDropActivityScreen({
    super.key,
    required this.activityId,
    required this.tokenService,
    this.onNavigate,
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

    try {
      final service = QuestionService(
        tokenService: widget.tokenService,
      );

      final success = await service.postDragAndDropActivity(
        activityId: widget.activityId,
        originalSequence: _optionsController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          success ? 'Atividade enviada com sucesso!' : 'Erro ao enviar atividade.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) {
        widget.onNavigate?.call(0);
        if (widget.onNavigate == null) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro: $e'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Cadastrar Arrasta-e-Solta',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Digite a instrução e as opções separadas por ponto e vírgula.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _instructionController,
                        decoration: const InputDecoration(
                          labelText: 'Instrução',
                          border: OutlineInputBorder(),
                          fillColor: Color(0xFFF4F7F8),
                          filled: true,
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Obrigatório' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _optionsController,
                        decoration: const InputDecoration(
                          labelText: 'Opções (separadas por ";")',
                          border: OutlineInputBorder(),
                          fillColor: Color(0xFFF4F7F8),
                          filled: true,
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Obrigatório' : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD965),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'Cadastrar >',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
