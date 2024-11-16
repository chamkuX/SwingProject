// splash_screen.dart
import 'package:flutter/material.dart';
import 'register_now_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterNowScreen()),
      );
    });

    return const Scaffold(
      body: Center(
        child: Text('Welcome to Swing', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
