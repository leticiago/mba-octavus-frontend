import 'package:flutter/material.dart';
import '../services/professorservice.dart';
import '../models/studentmodel.dart';

class GerenciarAlunosScreen extends StatefulWidget {
  final String professorId;
  final ProfessorService professorService;
  final void Function(int) onNavigate;

  const GerenciarAlunosScreen({
    Key? key,
    required this.professorId,
    required this.professorService,
    required this.onNavigate,
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
            const Text(
              'Alunos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                      ? Center(child: Text(error!))
                      : alunos.isEmpty
                          ? const Center(child: Text('Nenhum aluno vinculado.'))
                          : ListView.builder(
                              itemCount: alunos.length,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final aluno = alunos[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: Colors.amber[200],
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              aluno.name,
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            // Text(
                                            //   aluno.course ?? '',
                                            //   style: const TextStyle(color: Colors.grey),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Botão + pressionado para ${aluno.name}')),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.link_off, color: Colors.green),
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
}
