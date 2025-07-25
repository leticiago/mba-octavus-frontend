import 'package:flutter/material.dart';
import 'package:octavus/services/Auth/token_service.dart';
import 'package:octavus/widgets/Student/main_scaffold_aluno.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/Login/login_screen.dart';
import '../views/Common/tutorial_screen.dart';
import '../views/Login/register_screen.dart';
import '../views/Profile/profile_setup_screen.dart';
import '../views/Common/initial_screen.dart';
import '../views/Activity/Professor/create_question_and_answer_activity_screen.dart';
import '../views/Activity/Professor/create_drag_and_drop_activity.dart';
import '../views/Activity/Professor/create_free_text_activity.dart';
import '../widgets/Professor/main_scaffold.dart';

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

  static Future<String?> _getSavedActivityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('createdActivityId');
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final tokenService = TokenService();

    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const InitialScreen());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case profileSetup:
        return MaterialPageRoute(
          builder: (context) => const ProfileSetupScreen(),
          settings: settings,
        );


      case tutorial:
        return MaterialPageRoute(builder: (_) => const TutorialScreen());

      case homeAluno:
        return MaterialPageRoute(
          builder: (_) => MainScaffoldAluno(
            initialIndex: 0,
          ),
        );

      case homeProfessor:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277/api',
            initialIndex: 0,
          ),
        );

      case professorProfile:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277/api',
            initialIndex: 2,
          ),
        );

      case linkStudent:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277/api',
            initialIndex: 4,
          ),
        );

      case manageStudents:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277/api',
            initialIndex: 3,
          ),
        );

      case criarAtividade:
        return MaterialPageRoute(
          builder: (_) => MainScaffold(
            role: 'professor',
            baseUrl: 'http://10.0.2.2:5277/api',
            initialIndex: 6,
          ),
        );

      case '/criar-pergunta-resposta':
        final args = settings.arguments as void Function(int)?;
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<String?>(
            future: _getSavedActivityId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: Text('ID da atividade não encontrado')),
                );
              } else {
                return CreateQuestionAndAnswerActivityScreen(
                  activityId: snapshot.data!,
                  onNavigate: args,
                  tokenService: tokenService,
                );
              }
            },
          ),
        );

      case '/criar-arrasta-solta':
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<String?>(
            future: _getSavedActivityId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: Text('ID da atividade não encontrado')),
                );
              } else {
                return CreateDragAndDropActivityScreen(
                  activityId: snapshot.data!,
                  tokenService: tokenService,
                );
              }
            },
          ),
        );

      case '/criar-livre':
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<String?>(
            future: _getSavedActivityId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError || !snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: Text('ID da atividade não encontrado')),
                );
              } else {
                return CreateFreeTextActivityScreen(
                  activityId: snapshot.data!,
                  tokenService: tokenService,
                );
              }
            },
          ),
        );

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
