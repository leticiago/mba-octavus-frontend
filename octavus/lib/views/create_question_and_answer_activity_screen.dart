import 'package:flutter/material.dart';
import 'package:octavus/models/forms/question_form_data.dart';
import 'package:octavus/services/questionservice.dart';

class CreateQuestionAndAnswerActivityScreen extends StatefulWidget {
  final String activityId;

  const CreateQuestionAndAnswerActivityScreen({
    super.key,
    required this.activityId,
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
  final String baseUrl = 'http://10.0.2.2:5277';

  void updateNumberOfQuestions(int value) {
    setState(() {
      numberOfQuestions = value;
      if (questions.length < value) {
        questions.addAll(List.generate(
            value - questions.length, (_) => QuestionFormData()));
      } else {
        questions.removeRange(value, questions.length);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final service = QuestionService();
    final success = await service.postQuestions(
      activityId: widget.activityId,
      questions: questions,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(success
          ? 'Perguntas cadastradas com sucesso!'
          : 'Erro ao cadastrar perguntas.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Cadastrar Pergunta–Resposta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 20),

                _buildDropdownQtd(),

                const SizedBox(height: 20),
                for (int i = 0; i < numberOfQuestions; i++)
                  _buildQuestionCard(i),

                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ),
          ),
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

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD965),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: _submit,
      child: const Text(
        'Cadastrar  >',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
