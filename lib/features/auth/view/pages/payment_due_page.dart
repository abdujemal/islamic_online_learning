import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/constants.dart';

class PaymentDuePage extends StatefulWidget {
  const PaymentDuePage({super.key});

  @override
  State<PaymentDuePage> createState() => _PaymentDuePageState();
}

class _PaymentDuePageState extends State<PaymentDuePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
      lowerBound: 0.92,
      upperBound: 1,
    );

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPayPressed() async {
    await _controller.reverse();
    await _controller.forward();

    // TODO: navigate to your payment page
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xff0F172A)
          : const Color(0xffF9FAFB),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Beautiful glowing icon
                Container(
                  padding: const EdgeInsets.all(35),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.shade200,
                        primaryColor.shade400,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 8,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "የክፍያ ጊዜ ደርሷል",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                Text(
                  "ትምህርቱን ለመቀጠል እባክዎ ክፍያዎን ያድሱ።\n"
                  "ምክንያቱም እውቀት መፈለግ የማይቋረጥ ጉዞ ነው።",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: theme.brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 40),

                ScaleTransition(
                  scale: _scale,
                  child: GestureDetector(
                    onTapDown: (_) => _controller.reverse(),
                    onTapCancel: () => _controller.forward(),
                    onTapUp: (_) => _onPayPressed(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 32),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            offset: const Offset(0, 5),
                            blurRadius: 18,
                          )
                        ],
                      ),
                      child: Text(
                        "ክፍያውን ያክሉ",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TextButton(
                //   onPressed: () {},
                //   child: Text(
                //     "አሁን አልችልም?",
                //     style: TextStyle(
                //       color: theme.colorScheme.primary,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
