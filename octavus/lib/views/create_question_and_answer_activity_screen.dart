import 'package:flutter/material.dart';
import '../models/forms/question_form_data.dart';


class CreateQuestionAnswerActivityScreen extends StatefulWidget {
  const CreateQuestionAnswerActivityScreen({super.key});

  @override
  State<CreateQuestionAnswerActivityScreen> createState() =>
      _CreateQuestionAnswerActivityScreenState();
}

class _CreateQuestionAnswerActivityScreenState
    extends State<CreateQuestionAnswerActivityScreen> {
  int numberOfQuestions = 1;

  final List<QuestionFormData> questions = [QuestionFormData()];

  final List<int> questionAmountOptions = [1, 2, 3, 4, 5];

  void updateNumberOfQuestions(int newValue) {
    setState(() {
      numberOfQuestions = newValue;
      
      if (questions.length < newValue) {
        questions.addAll(List.generate(newValue - questions.length, (_) => QuestionFormData()));
      } else if (questions.length > newValue) {
        questions.removeRange(newValue, questions.length);
      }
    });
  }

  void _submit() {
    for (var question in questions) {
      print("Pergunta: ${question.titleController.text}");
      for (var answer in question.answers) {
        print("- ${answer.textController.text} [${answer.isCorrect ? 'Correta' : 'Errada'}]");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ListView(
            children: [
              const Text(
                'Cadastrar Pergunta-Resposta',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              InputDecorator(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.bookmark_outline),
                  labelText: 'Número de perguntas',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: numberOfQuestions,
                    items: questionAmountOptions.map((n) {
                      return DropdownMenuItem(
                        value: n,
                        child: Text(n.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) updateNumberOfQuestions(value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              for (int i = 0; i < numberOfQuestions; i++) ...[
                Container(
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
                        controller: questions[i].titleController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.event_note),
                          labelText: 'Pergunta ${i + 1} - Descrição',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (int j = 0; j < 3; j++) _buildAnswerField(questions[i].answers[j], j),
                    ],
                  ),
                ),
              ],

              ElevatedButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerField(AnswerFormData data, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: data.textController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.event_note),
                labelText: 'Alternativa ${String.fromCharCode(65 + index)}',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<bool>(
              value: data.isCorrect,
              decoration: InputDecoration(
                labelText: 'Correta',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: true, child: Text('Correta')),
                DropdownMenuItem(value: false, child: Text('Errada')),
              ],
              onChanged: (value) {
                setState(() {
                  data.isCorrect = value ?? false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
