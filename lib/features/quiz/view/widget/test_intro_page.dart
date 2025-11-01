import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/constants.dart';

class TestIntroPage extends StatelessWidget {
  final String testTitle;
  final String duration;
  final bool unfinishedTest;
  final List<String> rules;
  final VoidCallback onStart;

  const TestIntroPage({
    super.key,
    required this.testTitle,
    required this.duration,
    required this.rules,
    required this.onStart,
    required this.unfinishedTest,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(           
            children: [
              // 🌿 Title Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade200.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.quiz, size: 60, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      testTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "የተሰጠው ደቂቃ: $duration",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 35),
        
              // 🕊 Rules Section
              if (!unfinishedTest)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryTextTheme.bodyMedium?.color?.withOpacity(0.05) ?? Colors.black38..withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "ከመጀመርዎ በፊት",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        // color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "እባክዎ ትንሽ ጊዜ ወስደው ደንቦቹን በጥንቃቄ ያንብቡ:",
                      style: TextStyle(
                        fontSize: 15,
                        // color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...rules.map(
                      (rule) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_outline,
                                color: primaryColor, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                rule,
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  height: 1.5,
                                  // color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 45),
              // 🌙 Motivational Text
              const Text(
                "አላህ ግልፅነት፣ ትኩረት እና ስኬት ይስጥህ 🌙",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
        
              const SizedBox(height: 45),
              if (unfinishedTest) ...[
                Text(
                  "ይህንን ፈተና ከዚህ በፊት አስረክበዋል!",
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shadowColor: Colors.greenAccent.shade100,
                  ),
                  child: Text(
                    "ወደ ኋላ ተመለስ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
        
              // 🟢 Start Button
              if (!unfinishedTest)
                ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shadowColor: Colors.greenAccent.shade100,
                  ),
                  child: Text(
                    "ፈተናውን ጀምር",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
