import 'package:flutter/material.dart';
import '../../../../services/user/studentservice.dart';
import '../../../services/Auth/user_session_service.dart';
import '../../../services/activity/questionservice.dart';

class AtividadeDragDropScreen extends StatefulWidget {
  final String activityId;

  const AtividadeDragDropScreen({
    super.key,
    required this.activityId,
  });

  @override
  State<AtividadeDragDropScreen> createState() => _AtividadeDragDropScreenState();
}

class _AtividadeDragDropScreenState extends State<AtividadeDragDropScreen> {
  List<String> opcoes = [];
  String originalSequence = '';
  bool isLoading = true;
  String? activityTitle;
  String? activityDescription;

  @override
  void initState() {
    super.initState();
    carregarOpcoes();
  }

  Future<void> carregarOpcoes() async {
    try {
      final data = await QuestionService().getDragAndDropOptions(widget.activityId);
      setState(() {
        opcoes = List<String>.from(data['shuffledOptions']);
        originalSequence = data['originalSequence'];
        activityTitle = data['title'] ?? 'Atividade';
        activityDescription = data['description'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar atividade.')),
      );
    }
  }

  Future<void> enviarResposta() async {
  final studentId = await UserSessionService.getUserId();
  if (studentId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Aluno não identificado.')),
    );
    return;
  }

  try {
    final result = await StudentService().submitDragAndDropAnswer(
      activityId: widget.activityId,
      studentId: studentId,
      orderedOptions: opcoes,
    );

    final String message = result['message'] ?? 'Resposta enviada com sucesso.';
    final double score = (result['score'] as num?)?.toDouble() ?? 0.0;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Resultado'),
        content: Text('$message\nPontuação: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao enviar resposta: $e')),
    );
  }
}


  Widget _buildTopBar() {
    return Container(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Expanded(
                          child: Text(
                            activityTitle ?? 'Atividade',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (activityDescription != null && activityDescription!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        activityDescription!,
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ReorderableListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: List.generate(opcoes.length, (index) {
                        final item = opcoes[index];
                        return Card(
                          key: ValueKey(item + index.toString()),
                          color: const Color(0xFFE3EAF6),
                          child: ListTile(
                            title: Text(item, style: const TextStyle(fontSize: 18)),
                            leading: const Icon(Icons.drag_handle),
                          ),
                        );
                      }),
                      onReorder: (oldIndex, newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) newIndex -= 1;
                          final item = opcoes.removeAt(oldIndex);
                          opcoes.insert(newIndex, item);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: enviarResposta,
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
