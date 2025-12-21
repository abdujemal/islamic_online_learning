import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PaymentCardShimmer extends StatelessWidget {
  const PaymentCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Shimmer.fromColors(
        baseColor:
              Theme.of(context).chipTheme.backgroundColor!.withAlpha(150),
          highlightColor: Theme.of(context).chipTheme.backgroundColor!,
        child: Row(
          children: [
            // Icon shimmer
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            const SizedBox(width: 16),

            // Text shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Provider title
                  Container(
                    height: 16,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Ref number
                  Container(
                    height: 14,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Date text
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Amount + status shimmer
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 12,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
