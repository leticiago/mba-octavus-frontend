import 'package:flutter/material.dart';
import '../../models/user_registration_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
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
                  _buildTextField(Icons.person, "Nome", _nameController),
                  _buildTextField(Icons.person_outline, "Sobrenome", _surnameController),
                  _buildTextField(Icons.account_circle_outlined, "Nome de usuário", _usernameController),
                  _buildTextField(Icons.email_outlined, "E-mail", _emailController,
                      validator: (value) {
                        if (value == null || !value.contains('@')) {
                          return 'Digite um e-mail válido';
                        }
                        return null;
                      }),
                  _buildTextField(Icons.lock_outline, "Senha", _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      }),
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
                      if (_formKey.currentState!.validate()) {
                        final registrationData = UserRegistration(
                          name: _nameController.text,
                          surname: _surnameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                          username: _usernameController.text,
                          contact: '',
                          profileId: '',
                          instrumentId: '',
                          roles: []
                        );

                        Navigator.pushNamed(
                          context,
                          '/profile',
                          arguments: registrationData,
                        );
                      }
                    },
                    child: const Text("Próximo"),
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
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hint,
    TextEditingController controller, {
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
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
