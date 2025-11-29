import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StreakCelebrationPage extends StatefulWidget {
  final int streakDays;
  const StreakCelebrationPage({super.key, required this.streakDays});

  @override
  State<StreakCelebrationPage> createState() => _StreakCelebrationPageState();
}

class _StreakCelebrationPageState extends State<StreakCelebrationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      lowerBound: 0.92,
      upperBound: 1,
    );

    _scale = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  void _onContinue() async {
    await _buttonController.reverse();
    await _buttonController.forward();

    // TODO: Navigate to next part of your app
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xff0F172A)
          : const Color(0xffF9FAFB),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// 🎉 Confetti (Lottie animation)
            Positioned(
              top: 0,
              child: Lottie.asset(
                "assets/animations/Confetti.json", // Add your Lottie file
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 🔥 Glowing streak circle
                // Container(
                //   padding: const EdgeInsets.all(40),
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     gradient: const LinearGradient(
                //       colors: [
                //         Color(0xffFACC15),
                //         Color(0xffEAB308),
                //       ],
                //     ),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.amber.withOpacity(0.4),
                //         blurRadius: 40,
                //         spreadRadius: 10,
                //       ),
                //     ],
                //   ),
                //   child: const Icon(
                //     Icons.local_fire_department_rounded,
                //     size: 70,
                //     color: Colors.white,
                //   ),
                // ),
                // Transform.scale(
                //   scale: scale.value,
                //   child: Container(
                //     padding: const EdgeInsets.all(28),
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.yellow.shade600.withOpacity(0.5),
                //           blurRadius: glow.value,
                //           spreadRadius: glow.value / 3,
                //         ),
                //       ],
                //     ),
                //     child:
                Lottie.asset(
                  'assets/animations/Streak.json',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                //   ),
                // ),
                const SizedBox(height: 30),

                Text(
                  "እንኳን ደስ አለዎት!",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "ዛሬም ትምህርትዎን ተጠናቀቁ።\n"
                  "በመማር ያደረጉትን ቁርጠኝነት በቀን ${widget.streakDays} ቀን ቀጥለዋል!",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 25),

                /// 🕌 Islamic Motivational Quote
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Text(
                    "“የሚማር ይህ የመንገድ ብርሃን ነው። አላህ ለሚያሣሉ የእውቀት መንገድን ያቀርባል።”",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 🎯 Bounce Continue Button
                ScaleTransition(
                  scale: _scale,
                  child: GestureDetector(
                    onTapDown: (_) => _buttonController.reverse(),
                    onTapCancel: () => _buttonController.forward(),
                    onTapUp: (_) => _onContinue(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 32,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffFACC15),
                            Color(0xffEAB308),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.4),
                            offset: const Offset(0, 5),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: Text(
                        "ቀጥሉ",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
