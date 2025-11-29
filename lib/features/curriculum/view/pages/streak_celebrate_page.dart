import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StreakCelebratePage extends StatefulWidget {
  final int streak;

  const StreakCelebratePage({super.key, required this.streak});

  @override
  State<StreakCelebratePage> createState() => _StreakCelebratePageState();
}

class _StreakCelebratePageState extends State<StreakCelebratePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    scaleAnim = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticOut,
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF0D0D0D), // Duolingo uses dark for celebrations
      body: Center(
        child: ScaleTransition(
          scale: scaleAnim,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🔥 Islamic flame Lottie (moon/star glow)
              Lottie.asset(
                'assets/animations/Streak.json',
                width: 230,
                height: 230,
                fit: BoxFit.contain,
                repeat: true,
              ),

              // 🔥 Streak number on top (like Duolingo)
              Positioned(
                top: 40,
                child: Text(
                  "${widget.streak}",
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.orange.shade500,
                        blurRadius: 30,
                      )
                    ],
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
