import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String amount;
  final String reference;
  final String bank;

  const PaymentSuccessPage({
    super.key,
    required this.amount,
    required this.reference,
    required this.bank,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor.withOpacity(0.15),
                theme.scaffoldBackgroundColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(),

                // Success Animation
                SizedBox(
                  height: 140,
                  child: Lottie.asset(
                    "assets/animations/success.json",
                    repeat: false,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Payment Successful",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Your subscription is now active",
                  style: TextStyle(
                    // color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                _summaryCard(theme),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MainPage(),
                              ),
                              (_) => false,
                            );
                          },
                          child: const Text("Go to Home Page"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // TextButton(
                      //   onPressed: () {
                      //     // View receipt
                      //   },
                      //   child: const Text("View Receipt"),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryCard(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          _row("Amount", "ETB $amount"),
          const Divider(height: 24),
          _row("Bank", bank),
          const Divider(height: 24),
          _row("Reference No", reference),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
