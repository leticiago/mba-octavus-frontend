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
import '../services/professorservice.dart';
import '../views/create_activity_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Octavus',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
