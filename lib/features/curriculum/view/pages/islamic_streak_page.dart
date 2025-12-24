import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';
import 'package:lottie/lottie.dart';

enum StreakType { Lesson, Discussion, Test }

class IslamicStreakPage extends ConsumerStatefulWidget {
  final String type;
  const IslamicStreakPage({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IslamicStreakPageState();
}

class _IslamicStreakPageState extends ConsumerState<IslamicStreakPage> {
  int streak = 0;
  int lessonsCompleted = 0;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final currentStreak = ref.read(currentStreakProvider);
      streak = currentStreak!.streakNo;
      lessonsCompleted = currentStreak.streak.scores.length;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Color primary = const Color(0xFF0F6F4F); // Islamic emerald
    final Color gold = const Color(0xFFD4AF37);

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Soft geometric islamic pattern background (Lottie recommended)
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.15,
                  child: Lottie.asset(
                    "assets/animations/Ramadan_Wheel.json",
                    repeat: true,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Stack(
                children: [
                  Lottie.asset(
                    "assets/animations/Confetti.json",
                    repeat: true,
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 40),

                      // Crescent Moon or Islamic learning animation

                      SizedBox(
                        height: 150,
                        child: Lottie.asset(
                          "assets/animations/Streak.json",
                          repeat: false,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "$streak-Day Streak",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Masha’Allah! You’re remaining consistent.",
                        style: TextStyle(
                          fontSize: 17,
                          // color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 25),
                      _islamicCard(primaryColor, gold),
                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 35),
                        child: SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              // Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MainPage(),
                                ),
                                (_) => false,
                              );
                            },
                            child: const Text(
                              "Back to Home Page",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _islamicCard(Color primary, Color gold) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(.15)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories, color: primary, size: 30),
              const SizedBox(width: 12),
              Text(
                "Today's ${widget.type} Complete",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _stat("Streak", "$streak Days", gold, primary),
              // if(widget.type == "Lesson")
              _stat("${widget.type}s Today", "$lessonsCompleted", gold, primary)
              // : SizedBox(),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            "“Seeking knowledge is a path of light. Stay consistent, "
            "and Allah will bless your journey.”",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              // color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, Color gold, Color primary) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: primary.withOpacity(.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
