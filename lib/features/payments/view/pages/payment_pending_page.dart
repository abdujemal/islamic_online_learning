import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:islamic_online_learning/features/payments/view/pages/payments_page.dart';
import 'package:lottie/lottie.dart';

class PaymentPendingPage extends StatefulWidget {
  final String amount;
  final String reference;
  final String bank;

  const PaymentPendingPage({
    super.key,
    required this.amount,
    required this.reference,
    required this.bank,
  });

  @override
  State<PaymentPendingPage> createState() => _PaymentPendingPageState();
}

class _PaymentPendingPageState extends State<PaymentPendingPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.amber.withOpacity(0.18),
                theme.scaffoldBackgroundColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                // Pending animation
                SizedBox(
                  height: 150,
                  child: Lottie.asset(
                    "assets/animations/pending.json",
                    repeat: false,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Payment Pending",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "We’ve received your payment details and are verifying it with the bank. "
                    "This usually takes a few minutes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                _statusCard(),

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
                            // Refresh payment status
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentsPage(),
                              ),
                            );
                          },
                          child: const Text("Check Status"),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // Refresh payment status
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MainPage(),
                              ),
                              (_) => false,
                            );
                          },
                          child: const Text("Go To Home Page"),
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     // Contact support
                      //   },
                      //   child: const Text("Contact Support"),
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

  Widget _statusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
          _row("Amount", "ETB ${widget.amount}"),
          const Divider(height: 24),
          _row("Bank", widget.bank),
          const Divider(height: 24),
          _row("Reference No", widget.reference),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.schedule, color: Colors.amber),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Verification in progress",
                  style: TextStyle(
                    // color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          )
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
        ),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ],
    );
  }
}
