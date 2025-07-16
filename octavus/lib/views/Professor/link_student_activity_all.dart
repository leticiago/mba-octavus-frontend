import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/instrument_model.dart';
import '../../models/student_model.dart';
import '../../models/activity_model.dart';
import '../../models/dtos/assignactivityrequest.dart';

import '../../services/common/instrument_service.dart';
import '../../services/professor/professor_service.dart';

class LinkActivityToStudentAllScreen extends StatefulWidget {
  final String professorId;
  final ProfessorService professorService;
  final void Function(int) onNavigate;

  const LinkActivityToStudentAllScreen({
    super.key,
    required this.professorId,
    required this.professorService,
    required this.onNavigate,
  });

  @override
  State<LinkActivityToStudentAllScreen> createState() =>
      _LinkActivityToStudentAllScreenState();
}

class _LinkActivityToStudentAllScreenState
    extends State<LinkActivityToStudentAllScreen> {
  List<Student> students = [];
  Student? selectedStudent;

  List<Instrument> instruments = [];
  Instrument? selectedInstrument;

  List<Activity> allActivities = [];
  List<Activity> filteredActivities = [];
  Activity? selectedActivity;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedStudents =
          await widget.professorService.getStudentsByProfessor(widget.professorId);
      final fetchedInstruments = await InstrumentService().getInstruments();
      final fetchedActivities =
          await widget.professorService.getActivitiesByProfessor(widget.professorId);

      setState(() {
        students = fetchedStudents;
        instruments = fetchedInstruments;
        allActivities = fetchedActivities;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  void _filterActivitiesByInstrument() {
    setState(() {
      selectedActivity = null;
      if (selectedInstrument != null) {
        filteredActivities = allActivities
            .where((a) => a.instrumentId == selectedInstrument!.id)
            .toList();
      } else {
        filteredActivities = [];
      }
    });
  }

  Future<void> _assignActivity() async {
    if (selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um aluno')),
      );
      return;
    }
    if (selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma atividade para vincular')),
      );
      return;
    }

    try {
      final request = AssignActivityRequest(
        studentId: selectedStudent!.id,
        activityId: selectedActivity!.id!,
      );
      await widget.professorService.assignActivityToStudent(request);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Atividade vinculada com sucesso!')),
      );
      widget.onNavigate(0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao vincular atividade: $e')),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF0F5F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => widget.onNavigate(0),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Vincular atividade',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selecione o aluno e a atividade para vincular.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    DropdownButtonFormField<Student>(
                      decoration: _inputDecoration('Aluno'),
                      items: students.map((student) {
                        return DropdownMenuItem<Student>(
                          value: student,
                          child: Text(student.name),
                        );
                      }).toList(),
                      value: selectedStudent,
                      onChanged: (value) =>
                          setState(() => selectedStudent = value),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<Instrument>(
                      decoration: _inputDecoration('Instrumento'),
                      items: instruments.map((inst) {
                        return DropdownMenuItem<Instrument>(
                          value: inst,
                          child: Text(inst.name),
                        );
                      }).toList(),
                      value: selectedInstrument,
                      onChanged: (value) {
                        setState(() => selectedInstrument = value);
                        _filterActivitiesByInstrument();
                      },
                    ),
                    const SizedBox(height: 16),

                    if (filteredActivities.isNotEmpty)
                      DropdownButtonFormField<Activity>(
                        decoration: _inputDecoration('Atividade'),
                        items: filteredActivities.map((act) {
                          return DropdownMenuItem<Activity>(
                            value: act,
                            child: Text(act.name),
                          );
                        }).toList(),
                        value: selectedActivity,
                        onChanged: (value) =>
                            setState(() => selectedActivity = value),
                      ),

                    if (selectedActivity != null) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        initialValue: selectedActivity!.description,
                        decoration: _inputDecoration('Descrição'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        initialValue: DateFormat('dd/MM/yyyy')
                            .format(selectedActivity!.date),
                        decoration: _inputDecoration('Data da atividade'),
                      ),
                    ],

                    const Spacer(),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF7E8B5),
                        ),
                        onPressed: _assignActivity,
                        child: const Text(
                          'Vincular >',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
