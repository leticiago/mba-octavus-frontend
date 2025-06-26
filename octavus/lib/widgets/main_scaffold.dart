import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/tokenservice.dart';
import '../services/user_session_service.dart';
import '../services/professorservice.dart';
import '../views/link_student_professor.dart';
import '../views/manage_students.dart';
import '../views/home_professor_screen.dart';
import '../views/initial_screen.dart';
import '../views/professor_profile.dart';
import '../views/create_activity_screen.dart';
import '../views/create_question_and_answer_activity_screen.dart';
import '../views/create_drag_and_drop_activity.dart';
import '../views/create_free_text_activity.dart';
import '../views/link_student_activity.dart';
import '../models/studentmodel.dart';

class MainScaffold extends StatefulWidget {
  final String role;
  final String baseUrl;
  final int initialIndex;

  const MainScaffold({
    Key? key,
    required this.role,
    this.baseUrl = 'http://10.0.2.2:5277/api',
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  String? token;
  String? userId;
  String? userName;
  String? activityId;
  bool _loading = true;
  bool _hasError = false;
  Student? _selectedStudentId;

  final GlobalKey<State<GerenciarAlunosScreen>> _gerenciarAlunosKey =
      GlobalKey<State<GerenciarAlunosScreen>>();

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      token = await TokenService.getToken();
      userId = await UserSessionService.getUserId();

      if (token != null) {
        userName = TokenService.extractNameFromToken(token!);
      }

      final prefs = await SharedPreferences.getInstance();
      activityId = prefs.getString('createdActivityId');

      if (token == null || userId == null || userName == null) {
        _hasError = true;
      }
    } catch (e) {
      _hasError = true;
    }

    setState(() {
      _loading = false;
    });
  }

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 3) {
        final state = _gerenciarAlunosKey.currentState;
        if (state != null) {
          (state as dynamic).loadAlunos();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError || token == null || userId == null || userName == null) {
      return const Scaffold(
        body: Center(child: Text("Erro ao carregar dados.")),
      );
    }

    final professorService = ProfessorService(
      baseUrl: widget.baseUrl,
    );

    final List<Widget> screens = [
      HomeProfessorScreen(
        professorService: professorService,
        onNavigate: _navigateTo,
      ),
      const InitialScreen(),
      PerfilProfessorScreen(onNavigate: _navigateTo),
      GerenciarAlunosScreen(
        key: _gerenciarAlunosKey,
        professorId: userId!,
        professorService: professorService,
        onNavigate: _navigateTo,
        onStudentSelected: (studentId) {
          setState(() {
            _selectedStudentId = Student(id: studentId, name: '');
            _selectedIndex = 9;
          });
        },
      ),
      VincularAlunoScreen(onBack: () => _navigateTo(3)),
      const CreateActivityScreen(),
      CreateQuestionAndAnswerActivityScreen(activityId: activityId ?? ''),
      CreateDragAndDropActivityScreen(activityId: activityId ?? ''),
      CreateFreeTextActivityScreen(activityId: activityId ?? ''),
      _selectedStudentId != null
          ? LinkActivityToStudentScreen(
              professorId: userId!,
              student: _selectedStudentId!,
              professorService: professorService,
              onNavigate: _navigateTo,
            )
          : const Center(child: Text('Nenhum aluno selecionado')),
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF35456b),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Olá, ${userName ?? 'professor'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF35456b),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF35456b),
            currentIndex: _selectedIndex > 2 ? 0 : _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            onTap: _navigateTo,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
              BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Atividades'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }
}
