import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/activity_model.dart';
import '../../../models/instrument_model.dart';
import '../../../services/common/instrument_service.dart';
import '../../../services/professor/professor_service.dart';
import '../../../services/auth/token_service.dart';
import '../../../services/auth/user_session_service.dart';

class CreateActivityScreen extends StatefulWidget {
  final void Function(int pageIndex, String activityId) onNavigateWithId;

  const CreateActivityScreen({
    super.key,
    required this.onNavigateWithId,
  });

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isPublic = false;
  int _type = 0;
  int _difficulty = 0;
  DateTime? _selectedDate;
  Instrument? _selectedInstrument;
  List<Instrument> _instruments = [];
  bool _isSubmitting = false;

  final List<String> _types = ['Pergunta e resposta', 'Arrasta e solta', 'Livre'];
  final List<String> _difficulties = ['Fácil', 'Médio', 'Difícil'];
  final Color lightYellow = const Color(0xFFF7E8B5);

  @override
  void initState() {
    super.initState();
    _loadInstruments();
  }

  Future<void> _loadInstruments() async {
    try {
      final instruments = await InstrumentService().getInstruments();
      setState(() => _instruments = instruments);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar instrumentos')),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submitActivity() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null || _selectedInstrument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final professorId = await UserSessionService.getUserId();
      final token = await TokenService().getToken();
      if (professorId == null || token == null) throw Exception('Sessão inválida');

      final activity = Activity(
        name: _titleController.text,
        description: _descriptionController.text,
        type: _type,
        date: _selectedDate!,
        level: _difficulty,
        isPublic: _isPublic,
        instrumentId: _selectedInstrument!.id,
        professorId: professorId,
      );

      final service = ProfessorService(
      baseUrl: 'http://10.0.2.2:5277/api',
      tokenService: TokenService(),
    );
      final activityId = await service.createActivity(activity);

      switch (_type) {
        case 0:
          widget.onNavigateWithId(6, activityId);
          break;
        case 1:
          widget.onNavigateWithId(7, activityId);
          break;
        case 2:
          widget.onNavigateWithId(8, activityId);
          break;
        default:
          widget.onNavigateWithId(0, '');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao criar atividade: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Cadastre uma atividade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 6),
              const Text(
                'Crie exercícios de pergunta e resposta, arrasta-e-solta ou livres para seus alunos',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              _buildDropdownField(
                label: 'Tipo',
                value: _type,
                items: _types,
                icon: Icons.bookmark_border,
                onChanged: (val) => setState(() => _type = val ?? 0),
                borderRadius: borderRadius,
              ),
              const SizedBox(height: 12),
              _buildInstrumentDropdown(borderRadius),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _titleController,
                label: 'Título',
                icon: Icons.edit,
                borderRadius: borderRadius,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _descriptionController,
                label: 'Descrição',
                icon: Icons.description,
                maxLines: 2,
                borderRadius: borderRadius,
              ),
              const SizedBox(height: 12),
              _buildDropdownField(
                label: 'Dificuldade',
                value: _difficulty,
                items: _difficulties,
                icon: Icons.stacked_bar_chart,
                onChanged: (val) => setState(() => _difficulty = val ?? 0),
                borderRadius: borderRadius,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7F8),
                    borderRadius: borderRadius,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Colors.black54),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Data'
                              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                          style: TextStyle(
                            color: _selectedDate == null ? Colors.black38 : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tornar atividade pública?', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: _isPublic,
                    activeColor: Colors.green,
                    onChanged: (value) => setState(() => _isPublic = value),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightYellow,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                    elevation: 0,
                  ),
                  onPressed: _isSubmitting ? null : _submitActivity,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text('Avançar >',
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required int? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<int?> onChanged,
    required BorderRadius borderRadius,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F8),
        borderRadius: borderRadius,
      ),
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.black54),
        ),
        value: value,
        items: List.generate(
          items.length,
          (index) => DropdownMenuItem(value: index, child: Text(items[index])),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildInstrumentDropdown(BorderRadius borderRadius) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F8),
        borderRadius: borderRadius,
      ),
      child: DropdownButtonFormField<Instrument>(
        value: _selectedInstrument,
        decoration: const InputDecoration(
          labelText: 'Instrumento',
          border: InputBorder.none,
          icon: Icon(Icons.music_note, color: Colors.black54),
        ),
        items: _instruments.map((inst) => DropdownMenuItem(value: inst, child: Text(inst.name))).toList(),
        onChanged: (value) => setState(() => _selectedInstrument = value),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    required BorderRadius borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F8),
        borderRadius: borderRadius,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) => value == null || value.isEmpty ? 'Obrigatório' : null,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.black54),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        ),
      ),
    );
  }
}
