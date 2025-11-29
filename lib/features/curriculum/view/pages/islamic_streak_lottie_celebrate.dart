import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IslamicStreakLottieCelebrate extends StatefulWidget {
  final int streak;

  const IslamicStreakLottieCelebrate({super.key, required this.streak});

  @override
  State<IslamicStreakLottieCelebrate> createState() =>
      _IslamicStreakLottieCelebrateState();
}

class _IslamicStreakLottieCelebrateState
    extends State<IslamicStreakLottieCelebrate>
    with SingleTickerProviderStateMixin {
  late AnimationController entrance;

  @override
  void initState() {
    super.initState();

    entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    entrance.forward();
  }

  @override
  void dispose() {
    entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // clean, premium, dark background
      body: Center(
        child: AnimatedBuilder(
          animation: entrance,
          builder: (context, child) {
            final scale = Tween<double>(begin: 0.35, end: 1.0)
                .animate(CurvedAnimation(
              parent: entrance,
              curve: Curves.elasticOut,
            ));

            final glow = Tween<double>(begin: 0, end: 35).animate(
              CurvedAnimation(parent: entrance, curve: Curves.easeOut),
            );

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔥 GLOW + LOTTIE ICON
                Transform.scale(
                  scale: scale.value,
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.shade600.withOpacity(0.5),
                          blurRadius: glow.value,
                          spreadRadius: glow.value / 3,
                        ),
                      ],
                    ),
                    child: Lottie.asset(
                      'assets/animations/Streak.json',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 🌙 Islamic congrat text
                AnimatedOpacity(
                  opacity: entrance.value,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      Text(
                        "Masha’Allah!",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow.shade500,
                          shadows: [
                            Shadow(
                              blurRadius: 25,
                              color: Colors.yellow.shade600.withOpacity(0.5),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "You've kept your learning streak",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${widget.streak} days",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.yellow.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
