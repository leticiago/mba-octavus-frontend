import 'package:flutter/material.dart';
import '../../services/auth/token_service.dart';
import '../../services/auth/user_session_service.dart';
import '../../services/professor/professor_service.dart';

class PerfilProfessorScreen extends StatefulWidget {
  final void Function(int) onNavigate;
  final int currentPageIndex; 

  const PerfilProfessorScreen({
    super.key,
    required this.onNavigate,
    required this.currentPageIndex,
  });

  @override
  State<PerfilProfessorScreen> createState() => _PerfilProfessorScreenState();
}

class _PerfilProfessorScreenState extends State<PerfilProfessorScreen> {
  String professorName = '...';
  int totalStudents = 0;
  int totalActivities = 0;

  late final TokenService _tokenService;
  late final ProfessorService _professorService;

  int? _lastPageIndex;

  @override
  void initState() {
    super.initState();
    _tokenService = TokenService();
    _professorService = ProfessorService(
      baseUrl: 'http://10.0.2.2:5277/api',
      tokenService: _tokenService,
    );
    _loadProfileData(); 
  }

  @override
  void didUpdateWidget(covariant PerfilProfessorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_lastPageIndex != widget.currentPageIndex &&
        widget.currentPageIndex == 3) { 
      _loadProfileData();
    }

    _lastPageIndex = widget.currentPageIndex;
  }

  Future<void> _loadProfileData() async {
    final token = await _tokenService.getToken();
    final userId = await UserSessionService.getUserId();

    if (token != null && userId != null) {
      final userName = _tokenService.extractNameFromToken(token);
      final students = await _professorService.getStudentsByProfessor(userId);
      final activities = await _professorService.getActivitiesByProfessor(userId);

      setState(() {
        professorName = userName ?? 'Professor(a)';
        totalStudents = students.length;
        totalActivities = activities.length;
      });
    }
  }

  void logout(BuildContext context) async {
    await _tokenService.removeToken();
    await UserSessionService.clearSession();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildProfileCard(),
          const SizedBox(height: 24),
          _buildOptionTile(
            context,
            title: 'Alunos',
            icon: Icons.group,
            onTap: () => widget.onNavigate(4),
          ),
          _buildDisabledOptionTile(title: 'Atividades', icon: Icons.assignment),
          _buildDisabledOptionTile(title: 'Configurações', icon: Icons.settings),
          const SizedBox(height: 16),
          _buildOptionTile(
            context,
            title: 'Sair',
            icon: Icons.logout,
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFD5DEEC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFD3C382),
          ),
          const SizedBox(height: 8),
          Text(professorName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ProfileInfoItem(label: 'Alunos', value: '$totalStudents'),
              _ProfileInfoItem(label: 'Atividades', value: '$totalActivities'),
              _ProfileInfoItem(label: 'XP', value: '10', faded: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFD5DEEC),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisabledOptionTile({required String title, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final bool faded;

  const _ProfileInfoItem({
    required this.label,
    required this.value,
    this.faded = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = faded ? Colors.black38 : Colors.black;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: textColor),
        ),
      ],
    );
  }
}
