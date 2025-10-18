import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class QuestionItemShimmer extends StatelessWidget {
  const QuestionItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).chipTheme.backgroundColor!.withAlpha(150),
      highlightColor: Theme.of(context).chipTheme.backgroundColor!,
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(18),
       
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress bar shimmer
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            // Question number shimmer
            Center(
              child: Container(
                height: 14,
                width: 140,
                color: Theme.of(context).cardColor,
              ),
            ),
            const SizedBox(height: 12),

            // Question text shimmer
            Container(
              height: 22,
              width: double.infinity,
              color: Theme.of(context).cardColor,
            ),
            const SizedBox(height: 8),
            Container(
              height: 22,
              width: MediaQuery.of(context).size.width * 0.6,
              color: Theme.of(context).cardColor,
            ),
            const SizedBox(height: 24),

            // Options shimmer
            ...List.generate(4, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).cardColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 30),

            // Buttons shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                Container(
                  height: 44,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Container(
                  height: 44,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
