import 'package:flutter/material.dart';
import 'views/initial_screen.dart';
import 'views/login_screen.dart'; 
import 'views/register_screen.dart'; 
import 'views/profile_setup_screen.dart'; 
import 'views/tutorial_screen.dart'; 

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
      routes: {
        '/': (context) => const InitialScreen(),
        '/login': (context) => const LoginScreen(), 
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileSetupScreen(),
        '/tutorial': (context) => const TutorialScreen(),
      },
    );
  }
}
