import 'package:flutter/material.dart';
import 'package:octavus/services/activity/question_service.dart';
import 'package:octavus/services/user/student_service.dart';
import 'package:octavus/services/auth/token_service.dart';
import '../../../services/Auth/user_session_service.dart';
import '../../../models/open_text_question_model.dart';

class AtividadeTextoScreen extends StatefulWidget {
  final String activityId;

  const AtividadeTextoScreen({super.key, required this.activityId});

  @override
  State<AtividadeTextoScreen> createState() => _AtividadeTextoScreenState();
}

class _AtividadeTextoScreenState extends State<AtividadeTextoScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;
  bool _isLoading = true;
  OpenTextQuestionModel? activityData;

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
      final data = await _questionService.getOpenTextActivity(widget.activityId);
      setState(() {
        activityData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao carregar atividade: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _submitAnswer() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escreva sua resposta.')),
      );
      return;
    }

    if (activityData == null) return;

    setState(() => _isSubmitting = true);

    try {
      final studentId = await UserSessionService.getUserId();
      if (studentId == null) throw Exception('ID do aluno não encontrado');

      final success = await _studentService.submitOpenTextAnswer(
        studentId: studentId,
        responseText: text,
        questionId: activityData!.id,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success
            ? 'Resposta enviada com sucesso!'
            : 'Erro ao enviar a resposta.'),
        backgroundColor: success ? Colors.green : Colors.red,
      ));

      if (success) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF35456B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Text(
                'Olá, aluno',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            activityData?.title ?? 'Atividade',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Submeta a resposta para que a atividade possa ser avaliada pelo seu professor',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F7F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration.collapsed(
                            hintText: 'Digite sua resposta aqui...',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitAnswer,
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
                          'Enviar >',
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
}
