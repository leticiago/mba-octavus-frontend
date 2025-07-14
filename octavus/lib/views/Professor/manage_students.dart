import 'package:flutter/material.dart';
import 'package:octavus/views/Common/student_progress_screen.dart';
import '../../services/professor/professorservice.dart';
import '../../models/student_model.dart';

class GerenciarAlunosScreen extends StatefulWidget {
  final String professorId;
  final ProfessorService professorService;
  final void Function(int) onNavigate;
  final void Function(String studentId) onStudentSelected;
  final void Function(String studentId)? onViewReport;

  const GerenciarAlunosScreen({
    Key? key,
    required this.professorId,
    required this.professorService,
    required this.onNavigate,
    required this.onStudentSelected,
    this.onViewReport,
  }) : super(key: key);

  @override
  State<GerenciarAlunosScreen> createState() => _GerenciarAlunosScreenState();
}

class _GerenciarAlunosScreenState extends State<GerenciarAlunosScreen> {
  List<Student> alunos = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    loadAlunos();
  }

  Future<void> loadAlunos() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final lista = await widget.professorService.getStudentsByProfessor(widget.professorId);
      setState(() {
        alunos = lista;
      });
    } catch (e) {
      setState(() {
        error = 'Erro ao carregar alunos: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> unlinkStudent(Student aluno) async {
    try {
      setState(() {
        alunos.remove(aluno);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aluno ${aluno.name} desvinculado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao desvincular aluno: $e')),
      );
    }
  }

  void addStudent() {
    widget.onNavigate(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => widget.onNavigate(0),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Alunos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                      ? Center(child: Text(error!))
                      : alunos.isEmpty
                          ? const Center(child: Text('Nenhum aluno vinculado.'))
                          : ListView.separated(
                              itemCount: alunos.length,
                              separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final aluno = alunos[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.amber,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          aluno.name,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ),

                                      // Botão para atribuir atividade (como antes)
                                      _actionButton(
                                        icon: Icons.add_circle,
                                        tooltip: 'Atribuir atividade',
                                        onPressed: () {
                                          widget.onStudentSelected(aluno.id);
                                        },
                                      ),
                                      const SizedBox(width: 4),

                                      _actionButton(
                                        icon: Icons.bar_chart,
                                        tooltip: 'Ver relatório',
                                        onPressed: () {
                                          if (widget.onViewReport != null) {
                                            widget.onViewReport!(aluno.id);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Função para visualizar relatório não implementada')),
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 4),

                                      // Botão para desvincular
                                      _actionButton(
                                        icon: Icons.link_off,
                                        tooltip: 'Desvincular aluno',
                                        onPressed: () => unlinkStudent(aluno),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: addStudent,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'Vincular Aluno',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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

  Widget _actionButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: const BoxDecoration(
        color: Color(0xFF5D7AAA),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: const Color(0xFFDDFE71)),
        onPressed: onPressed,
        iconSize: 20,
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        tooltip: tooltip,
      ),
    );
  }
}
