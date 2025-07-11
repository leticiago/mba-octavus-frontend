import 'package:flutter/material.dart';
import '../widgets/wave_clipper.dart';
import '../Login/welcome_screen.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Pratique de onde estiver',
      'description': 'Tenha acesso aos exercícios e materiais a qualquer hora e em qualquer lugar, direto no seu dispositivo. Aprenda no seu ritmo, sem limitações',
    },
    {
      'title': 'Se conecte com seus alunos',
      'description': 'Envie atividades, acompanhe o progresso dos seus alunos e ofereça feedback personalizado para um aprendizado mais eficiente e motivador',
    },
    {
      'title': 'Não pode corrigir atividades?\nAtue como um colaborador!',
      'description': 'Se você não pode corrigir, ainda assim pode ajudar como colaborador, revisando conteúdos, organizando materiais e apoiando a comunidade',
    },
  ];

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(userName: 'Fulano'),
          ),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          return Column(
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 350,
                  color: const Color(0xFF5D7AAA),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pages[index]['title']!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pages[index]['description']!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: CircleAvatar(
                  backgroundColor: Colors.yellow.shade100,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                    onPressed: _nextPage,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
