import 'package:flutter/material.dart';
import './manage_students.dart';
import '../services/TokenService.dart';
import '../services/user_session_service.dart';
import '../services/professorservice.dart';

class PerfilProfessorScreen extends StatelessWidget {
  final void Function(int) onNavigate;

  const PerfilProfessorScreen({super.key, required this.onNavigate});

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
            onTap: () async {
              final token = await TokenService.getToken();
              final professorId = await UserSessionService.getUserId();

              if (token == null || professorId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Usuário não autenticado')),
                );
                return;
              }

              onNavigate(3);
            },
          ),
          _buildOptionTile(
            context,
            title: 'Atividades',
            icon: Icons.assignment,
            onTap: () {
            },
          ),
          _buildOptionTile(
            context,
            title: 'Configurações',
            icon: Icons.settings,
            onTap: () {},
          ),
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

  void logout(BuildContext context) async {
    await TokenService.removeToken();
    await UserSessionService.clearSession();

    Navigator.of(context).pushReplacementNamed('/login');
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
          const Text('Fulano de Tal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _ProfileInfoItem(label: 'Alunos', value: '10'),
              _ProfileInfoItem(label: 'Atividades', value: '10'),
              _ProfileInfoItem(label: 'XP', value: '10'),
            ],
          )
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
}

class _ProfileInfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
