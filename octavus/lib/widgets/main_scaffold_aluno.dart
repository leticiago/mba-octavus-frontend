import 'package:flutter/material.dart';
import '../services/tokenservice.dart';
import '../views/home_student_screen.dart';
import '../views/metronome_screen.dart';
import '../views/student_profile.dart';
import '../views/student_activities_screen.dart';
import '../views/student_question_and_answer.dart';
import '../views/student_drag_and_drop.dart';
import '../views/student_free_text.dart';
import '../views/public_activities_screen.dart';

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
  bool _loading = true;

  final List<Widget?> screens = List.filled(7, null); // agora começa vazio

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadUserInfo();
    _initScreens();
  }

  void _initScreens() {
    screens[0] = HomeAlunoScreen(onNavigate: _navigateTo);
    screens[1] = PublicActivityScreen(onNavigate: _navigateTo);
    screens[2] = MetronomeScreen();
    screens[3] = PerfilAlunoScreen(onNavigate: _navigateTo);
    screens[4] = AlunoAtividadesScreen(onNavigate: _navigateTo);
    if (_selectedIndex >= 4 && widget.activityId != null) {
      switch (_selectedIndex) {
        case 4:
          screens[4] = AtividadeQuestionarioScreen(
            activityId: widget.activityId!,
            onNavigate: _navigateTo,
          );
          break;
        case 5:
          screens[5] = AtividadeDragDropScreen(activityId: widget.activityId!);
          break;
        case 6:
          screens[6] = AtividadeTextoScreen(activityId: widget.activityId!);
          break;
      }
    }
  }

  Future<void> _loadUserInfo() async {
    final token = await TokenService.getToken();
    if (token != null) {
      final name = TokenService.extractNameFromToken(token);
      setState(() {
        userName = name;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void _navigateTo(int index, {String? activityId}) {
    setState(() {
      _selectedIndex = index;

      if (index == 1) {
        screens[1] = PublicActivityScreen(onNavigate: _navigateTo);
      }

      if (index >= 4 && activityId != null) {
        switch (index) {
          case 4:
            screens[4] = AtividadeQuestionarioScreen(
              activityId: activityId,
              onNavigate: _navigateTo,
            );
            break;
          case 5:
            screens[5] = AtividadeDragDropScreen(activityId: activityId);
            break;
          case 6:
            screens[6] = AtividadeTextoScreen(activityId: activityId);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: _selectedIndex > 2
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
          screens.length,
          (i) => screens[i] ?? const SizedBox.shrink(), // evita erro null
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
        BottomNavigationBarItem(
                icon: Icon(Icons.music_note),
                label: 'Metrônomo',
              ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
                  ],
                ),
              ),
            )
    );
  }
}
