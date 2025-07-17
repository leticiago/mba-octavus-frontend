import 'package:flutter/material.dart';
import 'package:octavus/models/forms/question_form_data.dart';
import 'package:octavus/services/activity/question_service.dart';
import 'package:octavus/services/auth/interfaces/i_token_service.dart';

class CreateQuestionAndAnswerActivityScreen extends StatefulWidget {
  final String activityId;
  final ITokenService tokenService;
  final void Function(int)? onNavigate;

  const CreateQuestionAndAnswerActivityScreen({
    super.key,
    required this.activityId,
    required this.tokenService,
    this.onNavigate,
  });

  @override
  State<CreateQuestionAndAnswerActivityScreen> createState() =>
      _CreateQuestionAndAnswerActivityScreenState();
}

class _CreateQuestionAndAnswerActivityScreenState
    extends State<CreateQuestionAndAnswerActivityScreen> {
  int numberOfQuestions = 1;
  final List<int> questionAmountOptions = [1, 2, 3, 4, 5];
  final List<QuestionFormData> questions = [QuestionFormData()];

  final _formKey = GlobalKey<FormState>();

  void updateNumberOfQuestions(int value) {
    setState(() {
      numberOfQuestions = value;
      if (questions.length < value) {
        questions.addAll(
          List.generate(value - questions.length, (_) => QuestionFormData()),
        );
      } else {
        questions.removeRange(value, questions.length);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final service = QuestionService(
      tokenService: widget.tokenService,
    );
    final success = await service.postQuestions(
      activityId: widget.activityId,
      questions: questions,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Perguntas cadastradas com sucesso!'
              : 'Erro ao cadastrar perguntas.',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) widget.onNavigate?.call(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 80),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Cadastrar Pergunta–Resposta',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Crie questões com alternativas para esta atividade.',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownQtd(),
                    const SizedBox(height: 20),
                    for (int i = 0; i < numberOfQuestions; i++)
                      _buildQuestionCard(i),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 24,
              right: 24,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD965),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _submit,
                  child: const Text(
                    'Cadastrar >',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownQtd() {
    return InputDecorator(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.bookmark_outline),
        labelText: 'Número de perguntas',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: numberOfQuestions,
          items: questionAmountOptions
              .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
              .toList(),
          onChanged: (value) {
            if (value != null) updateNumberOfQuestions(value);
          },
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final question = questions[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF2F5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: question.titleController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.event_note),
              labelText: 'Pergunta ${index + 1} - Descrição',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: 16),
          for (int j = 0; j < 3; j++) _buildAnswerField(question, j),
        ],
      ),
    );
  }

  Widget _buildAnswerField(QuestionFormData question, int index) {
    final answer = question.answers[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: answer.textController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.event_note),
                labelText: 'Alternativa ${String.fromCharCode(65 + index)}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Obrigatório' : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<bool>(
              value: answer.isCorrect,
              decoration: InputDecoration(
                labelText: 'Correta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: true, child: Text('Correta')),
                DropdownMenuItem(value: false, child: Text('Errada')),
              ],
              onChanged: (val) {
                setState(() => answer.isCorrect = val ?? false);
              },
            ),
          ),
        ],
      ),
    );
  }
}
