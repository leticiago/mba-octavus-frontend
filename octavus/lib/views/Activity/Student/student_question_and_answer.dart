import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../services/questionservice.dart';
import '../../../../services/studentservice.dart';
import '../../../services/Auth/user_session_service.dart';

class AtividadeQuestionarioScreen extends StatefulWidget {
  final String activityId;
  final void Function(int)? onNavigate;

  const AtividadeQuestionarioScreen({super.key, required this.activityId, this.onNavigate});

  @override
  State<AtividadeQuestionarioScreen> createState() => _AtividadeQuestionarioScreenState();
}

class _AtividadeQuestionarioScreenState extends State<AtividadeQuestionarioScreen> {
  List<dynamic> questions = [];
  Map<String, String> selectedAnswers = {}; 
  bool isLoading = true;
  final QuestionService questionService = QuestionService();
  final StudentService studentService = StudentService();

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
  try {
    final data = await questionService.getQuestionsByActivityId(widget.activityId);
    setState(() {
      questions = data;
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Erro ao carregar perguntas.')),
    // );
  }
}


  void handleAnswerSelect(String questionId, String answerId) {
    setState(() {
      selectedAnswers[questionId] = answerId;
    });
  }

 void submitAnswers() async {
  if (selectedAnswers.length < questions.length) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Responda todas as perguntas antes de enviar.')),
    );
    return;
  }

  try {
    final studentId = await UserSessionService.getUserId();
    if (studentId == null) throw Exception('StudentId não encontrado');

    final answersList = selectedAnswers.entries.map((e) {
      return {
        "questionId": e.key,
        "selectedAnswerId": e.value,
      };
    }).toList();

    final result = await StudentService().submitQuestionAndAnswer(
      activityId: widget.activityId,
      studentId: studentId,
      answers: answersList,
    );

    final message = result['message']?.toString() ?? 'Resposta enviada!';
    final score = result['score']?.toString();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sucesso'),
        content: Text(score != null ? '$message\nPontuação: $score' : message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );

    if (mounted && widget is StatefulWidget && widget is dynamic && widget.onNavigate != null) {
      widget.onNavigate?.call(0);
    }

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao enviar respostas: $e')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF35456b),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Atividade – Escalas', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                final questionId = question['id'];
                final answers = question['answers'] as List<dynamic>;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xFFE3EAF6),
                  ),
                  child: ExpansionTile(
                    title: Text('Pergunta ${index + 1}'),
                    children: answers.map((answer) {
                      return RadioListTile<String>(
                        value: answer['id'],
                        groupValue: selectedAnswers[questionId],
                        onChanged: (value) => handleAnswerSelect(questionId, value!),
                        title: Text(answer['text']),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: submitAnswers,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD965),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Enviar  >',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
