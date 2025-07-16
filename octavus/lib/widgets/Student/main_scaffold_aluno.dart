import 'package:flutter/material.dart';
import 'package:octavus/services/auth/token_service.dart';
import 'package:octavus/services/user/student_service.dart';
import 'package:octavus/views/Common/student_progress_screen.dart';
import '../../services/auth/user_session_service.dart';
import '../../views/Home/home_student_screen.dart';
import '../../views/Common/metronome_screen.dart';
import '../../views/Profile/student_profile.dart';
import '../../views/Activity/Student/student_activities_screen.dart';
import '../../views/Activity/Student/student_question_and_answer.dart';
import '../../views/Activity/Student/student_drag_and_drop.dart';
import '../../views/Activity/Student/student_free_text.dart';
import '../../views/Common/public_activities_screen.dart';

class MainScaffoldAluno extends StatefulWidget {
  final int initialIndex;
  final String? activityId;

  const MainScaffoldAluno({Key? key, this.initialIndex = 0, this.activityId}) : super(key: key);

  @override
  State<MainScaffoldAluno> createState() => _MainScaffoldAlunoState();
}

class _MainScaffoldAlunoState extends State<MainScaffoldAluno> {
  int _selectedIndex = 0;
  String? userName;
  String? userId;
  bool _loading = true;

  late final StudentService studentService;
  final TokenService _tokenService = TokenService();
  final Map<int, Widget> _screens = {};

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    studentService = StudentService(tokenService: _tokenService);
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final token = await _tokenService.getToken();
    final id = await UserSessionService.getUserId();

    if (token != null && id != null) {
      final name = _tokenService.extractNameFromToken(token);
      setState(() {
        userName = name;
        userId = id;
        _loading = false;
      });
      _initScreens();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void _initScreens() {
    _screens[0] = HomeAlunoScreen(onNavigate: _navigateTo);
    _screens[1] = PublicActivityScreen(onNavigate: _navigateTo);
    _screens[2] = MetronomeScreen();
    _screens[3] = PerfilAlunoScreen(onNavigate: _navigateTo);
    _screens[4] = AlunoAtividadesScreen(onNavigate: _navigateTo);

    if (widget.activityId != null) {
      _screens[5] = AtividadeQuestionarioScreen(
        activityId: widget.activityId!,
        onNavigate: _navigateTo,
      );
      _screens[6] = AtividadeDragDropScreen(activityId: widget.activityId!);
      _screens[7] = AtividadeTextoScreen(activityId: widget.activityId!);
    }

    if (userId != null) {
      _screens[8] = StudentProgressScreen(
        studentId: userId!,
        onNavigate: _navigateTo,
      );
    }
  }

  void _navigateTo(int index, {String? activityId}) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 1:
          _screens[1] = PublicActivityScreen(onNavigate: _navigateTo);
          break;
        case 4:
          _screens[4] = AlunoAtividadesScreen(onNavigate: _navigateTo);
          break;
        case 5:
          if (activityId != null) {
            _screens[5] = AtividadeQuestionarioScreen(
              activityId: activityId,
              onNavigate: _navigateTo,
            );
          }
          break;
        case 6:
          if (activityId != null) {
            _screens[6] = AtividadeDragDropScreen(activityId: activityId);
          }
          break;
        case 8:
          if (userId != null) {
            _screens[8] = StudentProgressScreen(
              studentId: userId!,
              onNavigate: _navigateTo,
            );
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: _selectedIndex > 9
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF35456B),
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
                      'Olá, ${userName ?? 'aluno'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Icon(Icons.account_circle_outlined, color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(
          _selectedIndex + 1,
          (i) => _screens[i] ?? const SizedBox.shrink(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF35456B),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF35456B),
            currentIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            onTap: (index) {
              if (index == _selectedIndex) return;
              _navigateTo(index);
            },
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
