import 'package:flutter/material.dart';
import '../services/instrumentservice.dart';
import '../services/user_session_service.dart';
import '../services/tokenservice.dart';
import '../services/professorservice.dart';
import '../models/instrumentmodel.dart';
import '../models/studentprofessormodel.dart';

class VincularAlunoScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const VincularAlunoScreen({Key? key, this.onBack}) : super(key: key);

  @override
  State<VincularAlunoScreen> createState() => _VincularAlunoScreenState();
}

class _VincularAlunoScreenState extends State<VincularAlunoScreen> {
  final emailController = TextEditingController();
  List<Instrument> instrumentos = [];
  Instrument? selectedInstrument;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    InstrumentService().getInstruments().then((lista) {
      setState(() {
        instrumentos = lista;
        isLoading = false;
      });
    }).catchError((e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar instrumentos: $e')),
      );
    });
  }

  Future<void> vincularAluno() async {
    final token = await TokenService.getToken();
    final professorId = await UserSessionService.getUserId();

    if (emailController.text.isEmpty || selectedInstrument == null || professorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos corretamente.')),
      );
      return;
    }

    final studentProfessor = StudentProfessor(
      studentEmail: emailController.text,
      professorId: professorId,
      instrumentId: selectedInstrument!.id,
    );

    try {
      final service = ProfessorService(baseUrl: 'http://10.0.2.2:5277', token: token!);
      await service.linkStudent(studentProfessor);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aluno vinculado com sucesso!')),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (context.mounted) {
        if (widget.onBack != null) {
          widget.onBack!();
        } else {
          Navigator.pushReplacementNamed(context, '/manage-students');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao vincular aluno: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Vincular aluno", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Vincule um aluno ao seu usuário para que ele acesse suas atividades."),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Instrument>(
                    value: selectedInstrument,
                    items: instrumentos
                        .map((instrumento) => DropdownMenuItem(
                              value: instrumento,
                              child: Text(instrumento.name),
                            ))
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Instrumento',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedInstrument = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail do aluno',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE49C),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: vincularAluno,
                    child: const Text("Vincular >", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
    );
  }

  AppBar _buildAppBar() => AppBar(
        backgroundColor: const Color(0xFF2C3E66),
        title: const Text("Olá, professor"),
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        actions: const [
          Padding(padding: EdgeInsets.only(right: 16), child: Icon(Icons.account_circle)),
        ],
      );
}
