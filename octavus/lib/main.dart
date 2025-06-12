import 'package:flutter/material.dart';
import 'views/initial_screen.dart';
import 'views/login_screen.dart'; 
import 'views/register_screen.dart'; 
import 'views/profile_setup_screen.dart'; 
import 'views/tutorial_screen.dart'; 
import 'views/home_student_screen.dart'; 
import 'views/home_professor_screen.dart'; 
import 'views/professor_profile.dart';
import 'core/app_routes.dart';
import 'views/link_student_professor.dart';
import 'views/manage_students.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Octavus',
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const InitialScreen(),
        '/login': (context) => const LoginScreen(), 
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileSetupScreen(),
        '/tutorial': (context) => const TutorialScreen(),
        '/home-aluno': (context) => const HomeAlunoScreen(),
        '/home-professor': (context) => const HomeProfessorScreen(),
        '/professor-profile': (context) => PerfilProfessorScreen(onNavigate: (_) {}),
        '/link-student': (context) => const VincularAlunoScreen(),

      },
    );
  }
}
