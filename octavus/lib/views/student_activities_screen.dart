import 'package:flutter/material.dart';
import '../models/dtos/activitystudent.dart';
import '../services/studentservice.dart';
import '../services/user_session_service.dart';
import 'student_question_and_answer.dart';
import 'student_drag_and_drop.dart';
import 'student_free_text.dart';


class AlunoAtividadesScreen extends StatefulWidget {
  final void Function(int) onNavigate;

  const AlunoAtividadesScreen({super.key, required this.onNavigate});

  @override
  State<AlunoAtividadesScreen> createState() => _AlunoAtividadesScreenState();
}

class _AlunoAtividadesScreenState extends State<AlunoAtividadesScreen> {
  final StudentService studentService = StudentService();
  List<ActivityStudent> atividades = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      final studentId = await UserSessionService.getUserId();
      if (studentId == null) throw Exception('StudentId não encontrado');

      final fetchedActivities = await studentService.getActivities(studentId);
      setState(() {
        atividades = fetchedActivities;
        _loading = false;
      });
    } catch (e) {
      print('Erro ao carregar atividades: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => widget.onNavigate(0),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Minhas atividades',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: atividades.isEmpty
                  ? const Center(child: Text("Nenhuma atividade disponível."))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: atividades.length,
                      itemBuilder: (context, index) {
                        final atividade = atividades[index];
                        return _buildAtividadeItem(atividade);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildAtividadeItem(ActivityStudent atividade) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EAF6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            atividade.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            atividade.description,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.play_circle_outline, color: Colors.black54),
              onPressed: () => _abrirAtividade(atividade),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirAtividade(ActivityStudent atividade) {
    Widget tela;
    switch (atividade.type) {
      case 0:
        tela = AtividadeQuestionarioScreen(activityId: atividade.activityId);
        break;
      case 1:
        tela = AtividadeDragDropScreen(activityId: atividade.activityId);
        break;
      case 2:
        tela = AtividadeTextoScreen(activityId: atividade.activityId);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tipo de atividade desconhecido")),
        );
        return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => tela));
  }

  double _mapStatusToProgress(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.pending:
        return 0.2;
      case ActivityStatus.inProgress:
        return 0.5;
      case ActivityStatus.completed:
        return 1.0;
      default:
        return 0.0;
    }
  }
}
