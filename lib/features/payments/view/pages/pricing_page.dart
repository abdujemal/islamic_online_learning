// ignore_for_file: no_wildcard_variable_uses

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/payments/view/controller/payment_state.dart';
import 'package:islamic_online_learning/features/payments/view/controller/provider.dart';
import 'package:islamic_online_learning/features/payments/view/pages/payment_verification_page.dart';

class PricingPage extends ConsumerStatefulWidget {
  const PricingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PricingPageState();
}

class _PricingPageState extends ConsumerState<PricingPage> {
  int selectedTier = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(paymentNotifierProvider.notifier).getPriceTiers(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    // final state = ref.watch(paymentNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose your plan"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ref.watch(paymentNotifierProvider).tierMap(
              loading: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
              loaded: (_) => Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _billingToggle(primary, _),
                    const SizedBox(height: 30),
                    Builder(builder: (context) {
                      final currency = _.tiers[selectedTier].currency;
                      final amount = _.tiers[selectedTier].price;
                      final type = _.tiers[selectedTier].duration
                          .toLowerCase()
                          .replaceAll("ly", "");
                      return _planCard(
                        title:
                            "${_.tiers[selectedTier].duration} Plan", // ? "Yearly Plan" : "Monthly Plan",
                        price:
                            "$currency $amount / $type", //yearly ? "ETB 990 / year" : "ETB 99 / month",
                        subtitle: _.tiers[selectedTier].off == 0
                            ? "Pay monthly, cancel anytime"
                            : "Save ${_.tiers[selectedTier].off}% compared to monthly",
                        highlight: _.tiers[selectedTier].off != 0,
                        primary: primary,
                      );
                    }),
                    // const Spacer(),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: whiteColor,
                        ),
                        onPressed: () {
                          // navigate to payment
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PaymentVerificationPage(),
                            ),
                          );
                        },
                        child: const Text("Continue"),
                      ),
                    )
                  ],
                ),
              ),
              empty: (_) => const Center(
                child: Text("No pricing tiers available."),
              ),
              error: (_) => Center(
                child: Text("Error: ${_.tierError}"),
              ),
            ),
      ),
    );
  }

  Widget _billingToggle(Color primary, PaymentState state) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        // color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(state.tiers.length, (index) {
          final hasOff = state.tiers[index].off != 0;
          final off = state.tiers[index].off;
          return _toggleButton(
            hasOff
                ? "${state.tiers[index].duration} $off% OFF"
                : state.tiers[index].duration,
            selectedTier == index,
            () {
              ref.read(paymentNotifierProvider.notifier).toggleTier(index);
              setState(() {
                selectedTier = index;
              });
            },
          );
        }),

        // [

        //   _toggleButton("Monthly", !yearly, () {
        //     setState(() => yearly = false);
        //   }),
        //   _toggleButton("Yearly 17% OFF", yearly, () {
        //     setState(() => yearly = true);
        //   }),
        // ],
      ),
    );
  }

  Widget _toggleButton(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Theme.of(context).cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
            boxShadow:
                active ? [BoxShadow(color: Colors.black12, blurRadius: 6)] : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _planCard({
    required String title,
    required String price,
    required String subtitle,
    required bool highlight,
    required Color primary,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: highlight ? primary : Colors.grey.shade300),
        color: highlight ? primary.withOpacity(0.05) : Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(price,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 10),
          // const Text("✔ Unlimited payments"),
          // const Text("✔ SMS auto-detection"),
          // const Text("✔ Screenshot verification"),
          // const Text("✔ Priority support"),
        ],
      ),
    );
  }
}
