import 'package:flutter/material.dart';

import '../../models/activity_model.dart';
import '../../models/instrument_model.dart';
import '../../services/Activity/QuestionService.dart';
import '../../services/activity/activitypublicservice.dart';
import '../../services/common/instrumentservice.dart';
import '../../widgets/Student/main_scaffold_aluno.dart';

enum Level {
  beginner,
  intermediate,
  advanced,
}

String getLevelName(Level level) {
  switch (level) {
    case Level.beginner:
      return 'Iniciante';
    case Level.intermediate:
      return 'Intermediário';
    case Level.advanced:
      return 'Avançado';
  }
}

class PublicActivityScreen extends StatefulWidget {
  final void Function(int)? onNavigate;

  const PublicActivityScreen({super.key, this.onNavigate});

  @override
  State<PublicActivityScreen> createState() => _PublicActivityScreenState();
}

class _PublicActivityScreenState extends State<PublicActivityScreen> {
  late Future<List<Activity>> _activities;
  List<Activity> _allActivities = [];
  List<Activity> _filteredActivities = [];
  List<Instrument> _instruments = [];
  Instrument? _selectedInstrument;
  Level? _selectedLevel;
  bool _loadingInstruments = true;

  @override
  void initState() {
    super.initState();
    _loadInstruments();
    _activities = ActivityPublicService().fetchPublicActivities();
    _activities.then((value) {
      setState(() {
        _allActivities = value;
        _filteredActivities = value;
      });
    });
  }

  Future<void> _loadInstruments() async {
    try {
      final instruments = await InstrumentService().getInstruments();
      setState(() {
        _instruments = instruments;
        _loadingInstruments = false;
      });
    } catch (e) {
      setState(() {
        _loadingInstruments = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar instrumentos: $e')),
      );
    }
  }

  void _filterActivities() {
    setState(() {
      _filteredActivities = _allActivities.where((activity) {
        final matchesInstrument = _selectedInstrument == null ||
            activity.instrumentId == _selectedInstrument!.id;
        final matchesLevel = _selectedLevel == null ||
            activity.level == _selectedLevel!.index;
        return matchesInstrument && matchesLevel;
      }).toList();
    });
  }

  void _onInstrumentChanged(Instrument? instrument) {
    setState(() {
      _selectedInstrument = instrument;
    });
    _filterActivities();
  }

  void _onLevelChanged(Level? level) {
    setState(() {
      _selectedLevel = level;
    });
    _filterActivities();
  }

  void _openActivity(Activity activity) async {
    int initialIndex;

    switch (activity.type) {
      case 0:
        final questions =
            await QuestionService().getQuestionsByActivityId(activity.id!);
        if (questions.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Esta atividade ainda não possui perguntas.")),
          );
          return;
        }
        initialIndex = 4;
        break;
      case 1:
        initialIndex = 5;
        break;
      case 2:
        initialIndex = 6;
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tipo de atividade não suportado.")),
        );
        return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MainScaffoldAluno(
          initialIndex: initialIndex,
          activityId: activity.id!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: const [
            Text(
              "Atividades da Comunidade",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 4),
            Text(
              "Procure por uma atividade filtrando por instrumento",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_loadingInstruments)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  DropdownButtonFormField<Instrument>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por instrumento',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    value: _selectedInstrument,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todos'),
                      ),
                      ..._instruments.map(
                        (instrument) => DropdownMenuItem(
                          value: instrument,
                          child: Text(instrument.name),
                        ),
                      ),
                    ],
                    onChanged: _onInstrumentChanged,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Level>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por nível',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    value: _selectedLevel,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todos'),
                      ),
                      ...Level.values.map(
                        (level) => DropdownMenuItem(
                          value: level,
                          child: Text(getLevelName(level)),
                        ),
                      ),
                    ],
                    onChanged: _onLevelChanged,
                  ),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Activity>>(
              future: _activities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erro: ${snapshot.error}"));
                } else if (_filteredActivities.isEmpty) {
                  return const Center(child: Text("Nenhuma atividade pública encontrada."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredActivities.length,
                  itemBuilder: (context, index) {
                    final activity = _filteredActivities[index];
                    return Card(
                      color: const Color(0xFFe8edf5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(activity.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(activity.description),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                        onTap: () => _openActivity(activity),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
