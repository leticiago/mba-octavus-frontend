import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Olá,", style: TextStyle(fontSize: 18)),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Criar uma conta",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(Icons.person, "Nome"),
                _buildTextField(Icons.person_outline, "Sobrenome"),
                _buildTextField(Icons.account_circle_outlined, "Nome de usuário"),
                _buildTextField(Icons.email_outlined, "E-mail"),
                _buildTextField(Icons.lock_outline, "Senha", obscureText: true),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(value: false, onChanged: (_) {}),
                    const Flexible(
                      child: Text(
                        "Ao continuar, você aceita nossa política de privacidade e termos de uso.",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE899),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: const Text("Cadastrar"),
                ),
                const SizedBox(height: 12),
                const Text("Ou"),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.facebook, color: Colors.blue),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                    onPressed: () {
                        Navigator.pushNamed(context, '/login');
                    },
                    child: const Text.rich(
                        TextSpan(
                        text: "Já possui uma conta? ",
                        children: [
                            TextSpan(
                            text: "Entrar",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFEFF3F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
