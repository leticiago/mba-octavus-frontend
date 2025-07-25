import 'package:flutter/material.dart';
import 'package:octavus/services/common/instrument_service.dart';
import 'package:octavus/services/professor/professor_service.dart';
import 'package:octavus/services/user/student_service.dart';
import 'package:octavus/services/auth/token_service.dart';
import 'package:octavus/views/Common/metronome_screen.dart';
import 'package:octavus/views/Common/public_activities_screen.dart';
import 'package:octavus/views/Common/student_progress_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/Auth/user_session_service.dart';

import '../../models/student_model.dart';
import '../../views/Home/home_student_screen.dart';
import '../../views/Professor/link_student_professor.dart';
import '../../views/Professor/manage_students.dart';
import '../../views/Home/home_professor_screen.dart';
import '../../views/Profile/professor_profile.dart';
import '../../views/Activity/Professor/create_activity_screen.dart';
import '../../views/Activity/Professor/create_question_and_answer_activity_screen.dart';
import '../../views/Activity/Professor/create_drag_and_drop_activity.dart';
import '../../views/Activity/Professor/create_free_text_activity.dart';
import '../../views/Professor/link_student_activity.dart';
import '../../views/Professor/link_student_activity_all.dart';
import '../../views/Professor/evaluate_activity_screen.dart';

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
  late final TokenService _tokenService;
  late ProfessorService professorService;
  late StudentService studentService;
  late InstrumentService instrumentService;

  int _selectedIndex = 0;
  String? token;
  String? userId;
  String? userName;
  String? activityId;
  bool _loading = true;
  bool _hasError = false;

  Student? _selectedStudentId;
  String? _evaluateStudentId;
  String? _evaluateActivityId;
  String? _evaluateStudentResponse;

  final GlobalKey<State<GerenciarAlunosScreen>> _gerenciarAlunosKey =
      GlobalKey<State<GerenciarAlunosScreen>>();

  String? createdActivityId;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _tokenService = TokenService();
    professorService = ProfessorService(
      baseUrl: widget.baseUrl,
      tokenService: _tokenService,
    );
    studentService = StudentService(
      baseUrl: widget.baseUrl,
      tokenService: _tokenService,
    );
    instrumentService = InstrumentService();

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      token = await _tokenService.getToken();
      userId = await UserSessionService.getUserId();

      if (token != null) {
        userName = _tokenService.extractNameFromToken(token!);
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

  void _navigateToWithActivityId(int index, String activityId) {
    setState(() {
      createdActivityId = activityId;
      _selectedIndex = index;
    });
  }

 Future<void> _openEvaluateActivity({
  required String studentId,
  required String activityId,
}) async {
  setState(() {
    _evaluateStudentId = studentId;
    _evaluateActivityId = activityId;
    _selectedIndex = 11; 
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

    if (widget.role == 'Aluno') {
      return HomeAlunoScreen(onNavigate: _navigateTo);
    }

    final List<Widget> screens = [
      HomeProfessorScreen(
        professorService: professorService,
        onNavigate: _navigateTo,
        onEvaluateActivity: _openEvaluateActivity,
      ),
      PublicActivityScreen(onNavigate: _navigateTo),
      MetronomeScreen(),
      PerfilProfessorScreen(onNavigate: _navigateTo, currentPageIndex: _selectedIndex),
      GerenciarAlunosScreen(
        key: _gerenciarAlunosKey,
        professorId: userId!,
        professorService: professorService,
        onNavigate: _navigateTo,
        onStudentSelected: (studentId) {
          setState(() {
            _selectedStudentId = Student(id: studentId, name: '');
            _selectedIndex = 10;
          });
        },
        onViewReport: (studentId) {
          setState(() {
            _selectedStudentId = Student(id: studentId, name: '');
            _selectedIndex = 13;
          });
        },
      ),
      VincularAlunoScreen(onBack: () => _navigateTo(3)),
      CreateActivityScreen(
        onNavigateWithId: _navigateToWithActivityId,
        ),
        CreateQuestionAndAnswerActivityScreen(
          activityId: createdActivityId ?? '',
          onNavigate: _navigateTo,
          tokenService: _tokenService, 
        ),
        CreateDragAndDropActivityScreen(
          activityId: createdActivityId ?? '',
          tokenService: _tokenService, 
        ),
        CreateFreeTextActivityScreen(
          activityId: createdActivityId ?? '',
          tokenService: _tokenService, 
        ),
        
      _selectedStudentId != null
          ? LinkActivityToStudentScreen(
              professorId: userId!,
              student: _selectedStudentId!,
              professorService: professorService,
              instrumentService: instrumentService,
              onNavigate: _navigateTo,
            )
          : const Center(child: Text('Nenhum aluno selecionado')),

      if (_evaluateStudentId != null && _evaluateActivityId != null)
        EvaluateActivityScreen(
          studentService: studentService,
          professorService: professorService,
          onNavigate: _navigateTo,
          studentId: _evaluateStudentId!,
          activityId: _evaluateActivityId!,
        )
      else
        const Center(child: Text('Carregando avaliação...')),

      LinkActivityToStudentAllScreen(
        professorId: userId!,
        professorService: professorService,
        onNavigate: (index) => setState(() => _selectedIndex = index),
        currentPageIndex: _selectedIndex,
      ),

      if (_selectedStudentId != null)
        StudentProgressScreen(
          studentId: _selectedStudentId!.id,
          onNavigate: _navigateTo,
        )
      else
        const Center(child: Text('Nenhum aluno selecionado')),
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
            currentIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            onTap: _navigateTo,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
              BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Atividades'),
              BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Metrônomo'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }
}
