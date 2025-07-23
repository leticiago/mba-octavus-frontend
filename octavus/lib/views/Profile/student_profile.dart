import 'package:flutter/material.dart';
import 'package:octavus/services/auth/token_service.dart';
import '../../services/Auth/user_session_service.dart';

class PerfilAlunoScreen extends StatefulWidget {
  final void Function(int) onNavigate;
  
  const PerfilAlunoScreen({super.key, required this.onNavigate});

  @override
  State<PerfilAlunoScreen> createState() => _PerfilAlunoScreenState();
}

class _PerfilAlunoScreenState extends State<PerfilAlunoScreen> {
  String alunoName = '...';
   final tokenService = TokenService();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
   
    final token = await tokenService.getToken();
    if (token != null) {
      final userName = tokenService.extractNameFromToken(token);
      setState(() {
        alunoName = userName ?? 'Aluno(a)';
      });
    }
  }

  void logout(BuildContext context) async {
    await tokenService.removeToken();
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
          _buildDisabledOptionTile(title: 'Minhas atividades', icon: Icons.assignment),
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
            backgroundColor: Color(0xFF5D7AAA),
            child: Icon(Icons.person, size: 30, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(alunoName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _ProfileInfoItem(label: 'Atividades', value: '', faded: true),
              _ProfileInfoItem(label: 'XP', value: '---', faded: true),
              _ProfileInfoItem(label: 'Nível', value: '---', faded: true),
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
