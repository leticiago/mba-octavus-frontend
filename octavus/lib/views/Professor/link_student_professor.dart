import 'package:flutter/material.dart';
import '../../services/common/instrumentservice.dart';
import '../../services/Auth/user_session_service.dart';
import '../../services/auth/tokenservice.dart';
import '../../services/professor/professorservice.dart';
import '../../models/instrumentmodel.dart';
import '../../models/studentprofessormodel.dart';

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
      final service = ProfessorService(baseUrl: 'http://10.0.2.2:5277');
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

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF0F5F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      prefixIcon: icon != null ? Icon(icon) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título e seta
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => widget.onBack?.call(),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Vincular aluno',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vincule um aluno da plataforma ao seu usuário para que ele possa ter acesso às suas atividades cadastradas.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    DropdownButtonFormField<Instrument>(
                      value: selectedInstrument,
                      items: instrumentos
                          .map((instrumento) => DropdownMenuItem(
                                value: instrumento,
                                child: Text(instrumento.name),
                              ))
                          .toList(),
                      decoration: _inputDecoration('Instrumento'),
                      onChanged: (value) {
                        setState(() {
                          selectedInstrument = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: emailController,
                      decoration: _inputDecoration('E-mail do aluno', icon: Icons.email),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFE49C),
                        ),
                        onPressed: vincularAluno,
                        child: const Text(
                          "Vincular >",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
