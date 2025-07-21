import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:octavus/services/auth/token_service.dart';

class WelcomeScreen extends StatelessWidget {
  final String userName;
  final TokenService tokenService;

  const WelcomeScreen({super.key, required this.userName, required this.tokenService});

  void _navigateAccordingToRole(BuildContext context) async {
    final token = await tokenService.getToken();
    if (token == null) {
      return;
    }

    final parts = token.split('.');
    if (parts.length != 3) {
      return;
    }

    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = jsonDecode(payload);

    final roles = payloadMap['realm_access']?['roles'] as List<dynamic>?;
    print(roles);

    if (roles != null && roles.contains('Aluno')) {
      print('entrou aqui');
      Navigator.pushReplacementNamed(context, '/home-aluno');
    } else {
      Navigator.pushReplacementNamed(context, '/home-professor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    'Bem vindo, $userName',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tudo certo agora, vamos estudar!',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFE9B0),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => _navigateAccordingToRole(context),
                    child: const Text(
                      'Ir para a home',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
