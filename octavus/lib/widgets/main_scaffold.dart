import 'package:flutter/material.dart';
import '../services/tokenservice.dart';
import '../services/user_session_service.dart';
import '../services/professorservice.dart';
import '../views/link_student_professor.dart';
import '../views/manage_students.dart';
import '../views/home_professor_screen.dart';
import '../views/initial_screen.dart';
import '../views/professor_profile.dart';

class MainScaffold extends StatefulWidget {
  final String role;
  final String? baseUrl;
  final int initialIndex;

  const MainScaffold({
    Key? key,
    required this.role,
    this.baseUrl,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  String? token;
  String? userId;
  bool _loading = true;
  bool _hasError = false;

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

      if (token == null || userId == null) {
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

    if (_hasError || token == null || userId == null) {
      return const Scaffold(
        body: Center(child: Text("Erro ao carregar dados.")),
      );
    }

    final professorService = ProfessorService(
      baseUrl: widget.baseUrl ?? 'http://10.0.2.2:5277',
      token: token!,
    );

    final List<Widget> screens = [
      const HomeProfessorScreen(), 
      const InitialScreen(),
      PerfilProfessorScreen(onNavigate: _navigateTo),
      GerenciarAlunosScreen(
        key: _gerenciarAlunosKey,
        professorId: userId!,
        professorService: professorService,
        onNavigate: _navigateTo,
      ),
      VincularAlunoScreen(onBack: () => _navigateTo(3)),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 2 ? 0 : _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _navigateTo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Atividades'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
