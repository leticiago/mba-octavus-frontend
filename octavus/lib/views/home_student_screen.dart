import 'package:flutter/material.dart';
import '../services/tokenservice.dart';
import '../services/user_session_service.dart';
import '../services/studentservice.dart';
import '../models/activitymodel.dart';
import '../models/dtos/studentcompletedactivity.dart'; 

class HomeAlunoScreen extends StatefulWidget {
  final void Function(int) onNavigate;
  const HomeAlunoScreen({super.key, required this.onNavigate});

  @override
  State<HomeAlunoScreen> createState() => _HomeAlunoScreenState();
}

class _HomeAlunoScreenState extends State<HomeAlunoScreen> {
  String? userName;
  bool _loadingUser = true;
  bool _loadingActivities = true;

  List<StudentCompletedActivity> completedActivities = [];

  late final StudentService studentService;

  @override
  void initState() {
    super.initState();
    studentService = StudentService();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final token = await TokenService.getToken();
    if (token != null) {
      final name = TokenService.extractNameFromToken(token);
      setState(() {
        userName = name;
        _loadingUser = false;
      });
      await _loadCompletedActivities();
    } else {
      setState(() {
        _loadingUser = false;
        _loadingActivities = false;
      });
    }
  }

  Future<void> _loadCompletedActivities() async {
    try {
      final studentId = await UserSessionService.getUserId();
      if (studentId != null) {
        final activities = await studentService.getCompletedActivities(studentId);
        setState(() {
          completedActivities = activities;
          _loadingActivities = false;
        });
      } else {
        setState(() {
          _loadingActivities = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar atividades: $e');
      setState(() {
        _loadingActivities = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser || _loadingActivities) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildIconCardButton("Minhas atividades", Icons.arrow_right,
                  onTap: () {
                widget.onNavigate(3);
              }),
              _buildProgressCard(),
              const SizedBox(height: 12),
              _buildMetaCard("Desbloquear metas"),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Atividades recentes",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                    },
                    child: const Text("Ver mais",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (completedActivities.isEmpty)
                const Text("Nenhuma atividade concluída encontrada."),
              ...completedActivities
                  .map((activity) => _buildRecentActivity(
                      activity.title, "Pontuação: ${activity.score}"))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconCardButton(String text, IconData icon,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE7EDF8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(text),
          trailing: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF5A76A9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(icon, color: const Color(0xFFDDEF71)),
              onPressed: onTap,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDBE6F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ver relatórios de progresso",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEFE08D),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                },
                child: const Text("Ver mais"),
              ),
              const Icon(Icons.pie_chart, size: 48, color: Colors.blueGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCard(String title) {
    return Opacity(
      opacity: 0.4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDDEF71),
                foregroundColor: Colors.black,
              ),
              onPressed: null,
              child: const Text("Ir"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(String title, String score) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(score),
      trailing: const Icon(Icons.check_circle, color: Colors.green),
    );
  }
}
