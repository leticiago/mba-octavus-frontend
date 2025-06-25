import 'package:flutter/material.dart';
import '../services/questionservice.dart';

class CreateFreeTextActivityScreen extends StatefulWidget {
  final String activityId;

  const CreateFreeTextActivityScreen({
    super.key,
    required this.activityId,
  });

  @override
  State<CreateFreeTextActivityScreen> createState() =>
      _CreateFreeTextActivityScreenState();
}

class _CreateFreeTextActivityScreenState
    extends State<CreateFreeTextActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mediaUrlController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _mediaUrlController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final service = QuestionService();
      final success = await service.postFreeTextActivity(
        activityId: widget.activityId,
        title: _titleController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? 'Atividade cadastrada com sucesso!'
            : 'Erro ao cadastrar atividade.'),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) Navigator.pop(context);
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) =>
          value == null || value.trim().isEmpty ? 'Campo obrigatório' : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: const Color(0xFFF4F7F8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Atividade: Texto Livre'),
        backgroundColor: const Color(0xFFFFE48A),
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                _buildTextField(controller: _titleController, label: 'Título'),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Descrição',
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _mediaUrlController,
                  label: 'Mídia (link ou nome do arquivo)',
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE48A),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            'Cadastrar >',
                            style: TextStyle(fontSize: 18),
                          ),
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
