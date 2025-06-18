import 'package:flutter/material.dart';

import '../views/login_screen.dart';
import '../views/tutorial_screen.dart';
import '../views/home_student_screen.dart';
import '../views/home_professor_screen.dart';
import '../services/professorservice.dart';
import '../views/create_activity_screen.dart';
import '../views/register_screen.dart';
import '../views/profile_setup_screen.dart';
import '../views/professor_profile.dart';
import '../views/link_student_professor.dart';
import '../views/manage_students.dart';
import '../views/initial_screen.dart';
import '../views/create_question_and_answer_activity_screen.dart';
import '../widgets/main_scaffold.dart'; 

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String profileSetup = '/profile';
  static const String tutorial = '/tutorial';
  static const String homeAluno = '/home-aluno';
  static const String homeProfessor = '/home-professor';
  static const String professorProfile = '/professor-profile';
  static const String linkStudent = '/link-student';
  static const String manageStudents = '/manage-students';
  static const String criarAtividade = '/criar-atividade';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const InitialScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case profileSetup:
        return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());

      case tutorial:
        return MaterialPageRoute(builder: (_) => const TutorialScreen());

      case homeAluno:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'aluno',
            initialIndex: 0,
          ),
        );

      case homeProfessor:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277',
            initialIndex: 0,
          ),
        );

      case professorProfile:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277',
            initialIndex: 2, 
          ),
        );

      case linkStudent:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277',
            initialIndex: 4,
          ),
        );

      case manageStudents:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277',
            initialIndex: 3, 
          ),
        );

      case criarAtividade:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277',
            initialIndex: 5,
          ),
        );

      case '/criar-pergunta-resposta':
        return MaterialPageRoute(builder: (_) => const CreateQuestionAnswerActivityScreen());
      // case '/criar-arrasta-solta':
      //   return MaterialPageRoute(builder: (_) => const CreateDragAndDropActivityScreen());
      // case '/criar-livre':
      //   return MaterialPageRoute(builder: (_) => const CreateFreeActivityScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
            child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
