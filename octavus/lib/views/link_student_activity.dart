import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/instrumentmodel.dart';
import '../models/studentmodel.dart';
import '../models/activitymodel.dart';
import '../models/dtos/assignactivityrequest.dart';

import '../services/instrumentservice.dart';
import '../services/professorservice.dart';

class LinkActivityToStudentScreen extends StatefulWidget {
  final String professorId;
  final Student student;
  final ProfessorService professorService;
  final void Function(int) onNavigate;

  const LinkActivityToStudentScreen({
    super.key,
    required this.professorId,
    required this.student,
    required this.professorService,
    required this.onNavigate,
  });

  @override
  State<LinkActivityToStudentScreen> createState() => _LinkActivityToStudentScreenState();
}

class _LinkActivityToStudentScreenState extends State<LinkActivityToStudentScreen> {
  List<Instrument> instruments = [];
  Instrument? selectedInstrument;
  List<Activity> allActivities = [];
  List<Activity> filteredActivities = [];
  Activity? selectedActivity;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInstrumentsAndActivities();
  }

  Future<void> _loadInstrumentsAndActivities() async {
    try {
      final instrs = await InstrumentService().getInstruments();
      final acts = await widget.professorService.getActivitiesByProfessor(widget.professorId);

      setState(() {
        instruments = instrs;
        allActivities = acts;
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
    if (selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione uma atividade para vincular')),
      );
      return;
    }

    try {
      final request = AssignActivityRequest(
        studentId: widget.student.id,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(title: const Text('Vincular atividade')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vincule um exercício para que seu aluno pratique durante a semana',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<Instrument>(
                    decoration: const InputDecoration(
                      labelText: 'Instrumento',
                      border: OutlineInputBorder(),
                    ),
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
                      decoration: const InputDecoration(
                        labelText: 'Atividade',
                        border: OutlineInputBorder(),
                      ),
                      items: filteredActivities.map((act) {
                        return DropdownMenuItem<Activity>(
                          value: act,
                          child: Text(act.name),
                        );
                      }).toList(),
                      value: selectedActivity,
                      onChanged: (value) => setState(() => selectedActivity = value),
                    ),

                  if (selectedActivity != null) ...[
                    const SizedBox(height: 16),
                    Text(selectedActivity!.description),
                    const SizedBox(height: 4),
                    Text('Data: ${DateFormat('dd/MM/yyyy').format(selectedActivity!.date)}'),
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
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
