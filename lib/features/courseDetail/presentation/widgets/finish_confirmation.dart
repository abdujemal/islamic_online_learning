// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class FinishConfirmation extends ConsumerStatefulWidget {
  final VoidCallback action;
  final String title;
  const FinishConfirmation({
    super.key,
    required this.action,
    required this.title,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FinishConfirmationState();
}

class _FinishConfirmationState extends ConsumerState<FinishConfirmation> {
  late ConfettiController _controller, _controller1;
  bool showCup = false;

  @override
  void initState() {
    super.initState();

    _controller = ConfettiController(duration: const Duration(seconds: 1));
    _controller1 = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _controller1.dispose();
  }

  Align buildConfettiWidget(controller, double blastDirection) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        maximumSize: const Size(30, 30),
        shouldLoop: false,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.explosive,
        maxBlastForce: 20, // set a lower max blast force
        minBlastForce: 8, // set a lower min blast force
        emissionFrequency: 1,
        numberOfParticles: 8, // a lot of particles at once
        gravity: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).cardColor,
        child: SizedBox(
          height: showCup ? 300 : 165,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (showCup)
                        Image.asset(
                          "assets/cup.png",
                          width: 150,
                          height: 150,
                        ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      if (!showCup)
                        Text(
                          "${widget.title}ን ተምረው ጨርሰዋልን?",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      if (showCup)
                        const Text(
                          "እንኳን ደስ አልዎት!!",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      if (!showCup)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text(
                                "አይ",
                                style: TextStyle(
                                  color:
                                      ref.read(themeProvider) == ThemeMode.dark
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showCup = true;
                                });
                                _controller.play();
                                _controller1.play();

                                Future.delayed(const Duration(seconds: 6))
                                    .then((value) {
                                  widget.action();
                                });
                              },
                              child: Ink(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "አዎን",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                buildConfettiWidget(_controller, pi / 1),
                buildConfettiWidget(_controller1, pi / 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
