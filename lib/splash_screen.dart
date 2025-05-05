import 'package:flutter/material.dart';
import 'dart:async';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF10281B),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    letterSpacing: 1.2,
                  ),
                  children: [
                    TextSpan(
                      text: 'Eco',
                      style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
                    ),
                    TextSpan(
                      text: 'Mind',
                      style: TextStyle(color: Colors.green.shade400),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              CircularProgressIndicator(
                color: Colors.green.shade400,
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}