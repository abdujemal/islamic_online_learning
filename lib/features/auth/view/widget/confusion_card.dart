import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/telegram_wave_form.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/auth/model/confusion.dart';
import 'package:lottie/lottie.dart';

class ConfusionCard extends ConsumerStatefulWidget {
  final Confusion confusion;
  final VoidCallback playQuestion;
  final VoidCallback playAnswer;
  final bool isQuestionPlaying;
  final bool isAnswerPlaying;
  const ConfusionCard({
    super.key,
    required this.confusion,
    required this.playQuestion,
    required this.playAnswer,
    required this.isAnswerPlaying,
    required this.isQuestionPlaying,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ConfusionCardState();
}

class _ConfusionCardState extends ConsumerState<ConfusionCard> {
  @override
  Widget build(BuildContext context) {
    final answered = widget.confusion.response != null;
    final date = widget.confusion.createdAt.toString().split(" ")[0];
    final answerAudioUrl = widget.confusion.response;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: answered ? primaryColor : Colors.amber.shade700),
        // gradient: LinearGradient(
        //   colors: answered
        //       ? [const Color(0xffd1f7c4), const Color(0xfff0fff0)]
        //       : [const Color(0xfffee4e4), const Color(0xfffff5f5)],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- TOP ROW ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                answered ? "Answered" : "Pending",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color:
                      answered ? primaryColor.shade700 : Colors.amber.shade700,
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const SizedBox(height: 16),

          // ---------- QUESTION AUDIO BUTTON ----------
          GestureDetector(
            onTap: widget.playQuestion,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                // color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade50),
              ),
              child: Column(
                children: [
                  const Text(
                    "Question",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      myIcon(widget.isQuestionPlaying),
                      const SizedBox(width: 10),
                      Lottie.asset(
                        "assets/animations/recording.json",
                        height: 32,
                        repeat: true,
                        animate: widget.isQuestionPlaying,
                      ),
                      Lottie.asset(
                        "assets/animations/recording.json",
                        height: 32,
                        repeat: true,
                        animate: widget.isQuestionPlaying,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ---------- ANSWER AUDIO BUTTON ----------
          if (answered && answerAudioUrl != null)
            GestureDetector(
              onTap: widget.playAnswer,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade50),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Answer",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        myIcon(widget.isAnswerPlaying),
                        const SizedBox(width: 10),
                        Lottie.asset(
                          "assets/animations/recording.json",
                          height: 32,
                          repeat: true,
                          animate: widget.isAnswerPlaying,
                        ),
                        Lottie.asset(
                          "assets/animations/recording.json",
                          height: 32,
                          repeat: true,
                          animate: widget.isAnswerPlaying,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          if (!answered)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                // color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.yellow.shade100),
              ),
              child: const Text(
                "Your teacher will respond soon Insha’Allah",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }

  Widget myIcon(bool play) {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
      ),
      width: 40,
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: play
          ? const Icon(
              Icons.stop_rounded,
              size: 30,
              color: whiteColor,
            )
          : const Icon(
              Icons.play_arrow_rounded,
              size: 30,
              color: whiteColor,
            ),
    );
  }
}
