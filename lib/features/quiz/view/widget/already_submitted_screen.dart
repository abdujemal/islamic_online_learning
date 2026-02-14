import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:lottie/lottie.dart';

class AlreadySubmittedScreen extends StatelessWidget {
  final VoidCallback onBack;

  const AlreadySubmittedScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/success.json', // 👈 add your own animation
              width: 180,
              repeat: false,
            ),
            const SizedBox(height: 16),
            const Text(
              "ጥያቄ አስቀድሞ አስገብቷል።",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "ይህንን ጥያቄ ጨርሰዋል።\nአላህ ጥረትዎን ይባርክልዎ እውቀትንም የሚጠቅም ያድርግልዎ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                // color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: const Text(
                "🕊️ “እውቀትን በመሻት መንገድ የተራመደ ሰው አላህ የጀነት መንገድን ያቀላልለት።” — ነብያችን ﷺ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: primaryColor,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              label: const Text(
                "ወደ ዋናው ማውጫ ተመለስ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
