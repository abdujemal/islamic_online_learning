import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IslamicStreakPage extends StatefulWidget {
  final int streakDays;
  const IslamicStreakPage({super.key, required this.streakDays});

  @override
  State<IslamicStreakPage> createState() => _IslamicStreakPageState();
}

class _IslamicStreakPageState extends State<IslamicStreakPage>
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

  Future<void> _onContinue() async {
    await _buttonController.reverse();
    await _buttonController.forward();

    // TODO: Navigate to next page
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xff0D141B)
          : const Color(0xffF2EFE5),
      body: Stack(
        children: [
          /// 🕌 Soft Islamic pattern in background
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Image.asset(
                "assets/islamic_pattern.png", // Add your image
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Lottie.asset(
              "assets/animations/Confetti.json",
              height: 220,
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 🕌 Arabic Bismillah Calligraphy
                Text(
                  "﷽",
                  style: TextStyle(
                    fontSize: 60,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        blurRadius: 15,
                        color: Colors.black12,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ۞ Rub el Hizb Icon (Islamic)
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffD4AF37), // gold
                        Color(0xffC49B2D),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Text(
                    "۞",
                    style: TextStyle(
                      fontSize: 80,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Text(
                  "ዛሬም ትምህርትዎን አጠናቀቁ!",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "የእውቀት መንገድ በቀን ${widget.streakDays} ቀን ቀጥለዋል።",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 25),

                /// 📖 Beautiful Ayah / Hadith
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Text(
                    "“ማንም የእውቀት መንገድን ይከተል ከሆነ፣ "
                    "አላህ የገነት መንገድን ያቀርበዋል।”\n"
                        "— ሐዲስ",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.primary,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// ⭐ Bounce Continue Button
                ScaleTransition(
                  scale: _scale,
                  child: GestureDetector(
                    onTapDown: (_) => _buttonController.reverse(),
                    onTapCancel: () => _buttonController.forward(),
                    onTapUp: (_) => _onContinue(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 34,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff10A37F),
                            Color(0xff0F8F70),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            offset: const Offset(0, 5),
                            blurRadius: 18,
                          ),
                        ],
                      ),
                      child: Text(
                        "ቀጥሉ",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
