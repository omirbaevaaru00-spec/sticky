import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03060D),
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),

              const Positioned(
                left: 97,
                top: 248,
                child: SizedBox(
                  width: 246,
                  height: 51,
                  child: Text(
                    'WELCOME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                    ),
                  ),
                ),
              ),

              const Positioned(
                left: 40,
                right: 40,
                top: 318,
                child: Text(
                  'Найди университет, который подходит тебе.\n'
                  'Сравнивай программы и выбери свое будущее.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF8E95A3),
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              Positioned(
                left: 212,
                top: 641,
                child: SizedBox(
                  width: 158,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/quiz');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF35D9CC),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'пропустить',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}