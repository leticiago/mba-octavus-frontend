import 'package:flutter/material.dart';
import '../../services/professor/professor_service.dart';
import '../../services/user/student_service.dart';
import '../../models/open_text_answer_model.dart';

class EvaluateActivityScreen extends StatefulWidget {
  final ProfessorService professorService;
  final StudentService studentService;
  final void Function(int) onNavigate;
  final String studentId;
  final String activityId;

  const EvaluateActivityScreen({
    super.key,
    required this.studentId,
    required this.activityId,
    required this.professorService,
    required this.studentService,
    required this.onNavigate,
  });

  @override
  State<EvaluateActivityScreen> createState() => _EvaluateActivityScreenState();
}

class _EvaluateActivityScreenState extends State<EvaluateActivityScreen> {
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  OpenTextAnswer? _answer;
  bool _isLoading = true;

  String? _studentId;
  String? _activityId;

  @override
  void initState() {
  super.initState();

  _loadAnswer(widget.studentId, widget.activityId);
  }

  Future<void> _loadAnswer(String studentId, String activityId) async {
  print('Iniciando _loadAnswer');

  try {
    print('Chamando getOpenTextAnswer...');
    final fetchedAnswer = await widget.studentService.getOpenTextAnswer(
      activityId: activityId,
      studentId: studentId,
    );
    print('Resposta recebida: $fetchedAnswer');

    setState(() {
      _answer = fetchedAnswer;
      _isLoading = false;
    });
  } catch (e) {
    print('Erro no _loadAnswer: $e');
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao carregar resposta: $e')),
    );
  }
}


  Future<void> _submitEvaluation() async {
    final score = int.tryParse(_scoreController.text);
    final comment = _commentController.text;

    if (score == null || score < 0 || score > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nota deve ser entre 0 e 10')),
      );
      return;
    }

    if (widget.studentId.isEmpty || widget.activityId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados da avaliação não encontrados')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.professorService.evaluateActivity(
        studentId: widget.studentId,
        activityId: widget.activityId,
        score: score,
        comment: comment,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avaliação enviada com sucesso!')),
      );

      widget.onNavigate(0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar avaliação: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF0F5F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: icon != null ? Icon(icon, color: Colors.black54) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => widget.onNavigate(0),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Avaliar atividade',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Atribua uma nota e caso queira, deixe um comentário para essa atividade.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TextFormField(
                      initialValue: _answer?.responseText ?? 'Nenhuma resposta encontrada.',
                      readOnly: true,
                      maxLines: 3,
                      decoration: _inputDecoration('Resposta do aluno', icon: Icons.chat_bubble_outline),
                    ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _scoreController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Nota', icon: Icons.grade_outlined),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _commentController,
                maxLines: 3,
                decoration: _inputDecoration('Comentário', icon: Icons.comment_outlined),
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitEvaluation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7E8B5),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('Avaliar >', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
