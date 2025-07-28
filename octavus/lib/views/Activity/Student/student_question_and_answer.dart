import 'package:flutter/material.dart';
import 'package:octavus/services/activity/question_service.dart';
import 'package:octavus/services/user/student_service.dart';
import 'package:octavus/services/auth/token_service.dart';
import 'package:octavus/widgets/Professor/main_scaffold.dart';
import 'package:octavus/widgets/Student/main_scaffold_aluno.dart';
import '../../../services/Auth/user_session_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

String? getRoleFromToken(String token) {
  final decodedToken = JwtDecoder.decode(token);
  final roles = decodedToken['realm_access']?['roles'] as List<dynamic>?;

  if (roles == null) return null;

  if (roles.contains('Aluno')) return 'Aluno';
  if (roles.contains('Professor')) return 'Professor';
  if (roles.contains('Colaborador')) return 'Colaborador';

  return null;
}

class AtividadeQuestionarioScreen extends StatefulWidget {
  final String activityId;
  final void Function(int)? onNavigate;

  const AtividadeQuestionarioScreen({
    super.key,
    required this.activityId,
    this.onNavigate,
  });

  @override
  State<AtividadeQuestionarioScreen> createState() =>
      _AtividadeQuestionarioScreenState();
}

class _AtividadeQuestionarioScreenState
    extends State<AtividadeQuestionarioScreen> {
  List<dynamic> questions = [];
  Map<String, String> selectedAnswers = {};
  bool isLoading = true;

  String activityTitle = 'Atividade';

  late final TokenService _tokenService;
  late final QuestionService _questionService;
  late final StudentService _studentService;

  @override
  void initState() {
    super.initState();
    _tokenService = TokenService();
    _questionService = QuestionService(tokenService: _tokenService);
    _studentService = StudentService(tokenService: _tokenService);
    _loadActivityData();
  }

  Future<void> _loadActivityData() async {
    try {
      final data = await _questionService.getQuestionsByActivityId(widget.activityId);

      String? fetchedTitle;
      if (data.isNotEmpty) {
        fetchedTitle = data[0]['activityTitle'] ?? data[0]['activityName'];
      }

      setState(() {
        questions = data;
        activityTitle = fetchedTitle ?? 'Atividade';
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar perguntas: $e')),
      );
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
        const SnackBar(
            content: Text('Responda todas as perguntas antes de enviar.')),
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

      final result = await _studentService.submitQuestionAndAnswer(
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

      final token = await _tokenService.getToken();
      final role = (token != null) ? getRoleFromToken(token) : null;

      if (role == 'Aluno') {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScaffoldAluno()),
          );
        }
      } else if (role == 'Professor') {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScaffold(role: 'Professor')),
          );
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home-colaborador');
        }
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar respostas: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      activityTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),

            Expanded(
              child: ListView.builder(
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
                      color: const Color(0xFFE3EAF6),
                    ),
                    child: ExpansionTile(
                      title: Text(
                          question['title'] ?? 'Pergunta sem título',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      children: answers.map((answer) {
                        return RadioListTile<String>(
                          value: answer['id'],
                          groupValue: selectedAnswers[questionId],
                          onChanged: (value) =>
                              handleAnswerSelect(questionId, value!),
                          title: Text(answer['text']),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 50,
                width: double.infinity,
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
          ],
        ),
      ),
    );
  }
}
