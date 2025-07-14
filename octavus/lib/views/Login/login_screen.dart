import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:octavus/models/login_model.dart';
import '../../services/Auth/AuthenticationService.dart';
import '../../services/Auth/TokenService.dart';
import '../../utils/JwtUtils.dart';
import '../../widgets/Professor/main_scaffold.dart';
import '../../widgets/Student/main_scaffold_aluno.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  bool _isLoading = false;
  String? loggedUserName;

  @override
  void initState() {
    super.initState();
    _checkSavedToken();
  }

  Future<void> _checkSavedToken() async {
    final token = await TokenService.getToken();
    if (token != null) {
      final name = TokenService.extractNameFromToken(token);
      if (name != null && name.isNotEmpty) {
        setState(() {
          loggedUserName = name;
        });
      }
    }
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final user = User(
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    final token = await authService.login(user);

    setState(() => _isLoading = false);

    if (token != null) {
      await TokenService.saveToken(token);

      final name = TokenService.extractNameFromToken(token);
      setState(() {
        loggedUserName = name;
      });

      final role = getRoleFromToken(token);

      if (role == 'Aluno') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScaffoldAluno()),
        );
      } else if (role == 'Professor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScaffold(role: 'Professor')),
        );
      } else {
        Navigator.pushReplacementNamed(context, '/home-colaborador');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha no login. Verifique usuário e senha.')),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  loggedUserName != null
                      ? 'Bem-vindo, $loggedUserName'
                      : 'Olá!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              

              const SizedBox(height: 40),

              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: 'Username',
                  filled: true,
                  fillColor: const Color(0xFFEFF3F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: const Icon(Icons.visibility_off_outlined),
                  hintText: 'Senha',
                  filled: true,
                  fillColor: const Color(0xFFEFF3F6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Esqueceu a senha?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _login,
                  icon: const Icon(Icons.login, color: Colors.black),
                  label: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text("Entrar", style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE48A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Ou"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.facebookF),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(FontAwesomeIcons.google),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Ainda não possui uma conta? "),
                  GestureDetector(
                    onTap: _navigateToSignUp,
                    child: const Text(
                      "Crie agora",
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
