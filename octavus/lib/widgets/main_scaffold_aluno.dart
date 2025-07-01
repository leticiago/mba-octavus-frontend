import 'package:flutter/material.dart';
import '../services/tokenservice.dart';
import '../views/home_student_screen.dart';
import '../views/student_profile.dart';
import '../views/student_activities_screen.dart';

class MainScaffoldAluno extends StatefulWidget {
  final int initialIndex;

  const MainScaffoldAluno({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScaffoldAluno> createState() => _MainScaffoldAlunoState();
}

class _MainScaffoldAlunoState extends State<MainScaffoldAluno> {
  int _selectedIndex = 0;
  String? userName;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadUserInfo();
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

  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> screens = [
      HomeAlunoScreen(onNavigate: _navigateTo),         
      const Center(child: Text('Atividades')),          
      PerfilAlunoScreen(onNavigate: _navigateTo),       
      AlunoAtividadesScreen(onNavigate: _navigateTo),                          
    ];

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
                padding: const EdgeInsets.only(
                    top: 40, left: 20, right: 20, bottom: 10),
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
                    const Icon(Icons.account_circle_outlined,
                        color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: _selectedIndex <= 2
          ? Container(
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
                  currentIndex: _selectedIndex > 2 ? 0 : _selectedIndex,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white70,
                  onTap: _navigateTo,
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
                    BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Atividades'),
                    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
