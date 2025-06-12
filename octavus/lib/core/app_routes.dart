import 'package:flutter/material.dart';
import '../views/login_screen.dart';
import '../views/tutorial_screen.dart';
import '../views/home_student_screen.dart';
import '../views/home_professor_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String tutorial = '/tutorial';
  static const String homeAluno = '/home-aluno';
  static const String homeProfessor = '/home-professor';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case tutorial:
        return MaterialPageRoute(builder: (_) => const TutorialScreen());
      case homeAluno:
        return MaterialPageRoute(builder: (_) => const HomeAlunoScreen());
      case homeProfessor:
        return MaterialPageRoute(builder: (_) => const HomeProfessorScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Rota não encontrada: ${settings.name}')),
          ),
        );
    }
  }
}
