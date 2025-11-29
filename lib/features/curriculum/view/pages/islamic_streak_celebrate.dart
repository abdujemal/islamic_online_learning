import 'package:flutter/material.dart';

class IslamicStreakCelebrate extends StatefulWidget {
  final int streak;

  const IslamicStreakCelebrate({super.key, required this.streak});

  @override
  State<IslamicStreakCelebrate> createState() => _IslamicStreakCelebrateState();
}

class _IslamicStreakCelebrateState extends State<IslamicStreakCelebrate>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  late Animation<Color?> color;
  late Animation<double> glow;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    scale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ),
    );

    color = ColorTween(
      begin: Colors.grey.shade700,       // start dark
      end: Colors.yellow.shade600,       // end bright gold
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );

    glow = Tween<double>(begin: 0, end: 25).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
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
      backgroundColor: Colors.black, // no background animation
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ⭐ Crescent + Star Icon Animation
                Transform.scale(
                  scale: scale.value,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.value!.withOpacity(0.7),
                          blurRadius: glow.value,
                          spreadRadius: glow.value / 3,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mosque_rounded,
                      size: 140,
                      color: color.value,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // Streak Text
                AnimatedOpacity(
                  opacity: controller.value,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      Text(
                        "Masha’Allah!",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${widget.streak}-day streak",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.yellow.shade500,
                          fontWeight: FontWeight.w600,
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
