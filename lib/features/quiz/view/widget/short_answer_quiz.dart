import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';

class ShortAnswerQuiz extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> questions;
  final Duration timeLimit;
  final Function(List<Map<String, String>>) onFinish;
  final Function(Map<String, String>) onSubmit;

  const ShortAnswerQuiz({
    super.key,
    required this.questions,
    required this.onFinish,
    required this.onSubmit,
    required this.timeLimit,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShortAnswerQuizState();
}

class _ShortAnswerQuizState extends ConsumerState<ShortAnswerQuiz> {
  int currentIndex = 0;
  final Map<int, String> answers = {};
  final TextEditingController controller = TextEditingController();
  late Timer _timer;
  late int _remainingSeconds;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        timer.cancel();
        _showTimeUpDialog();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "⏰ የተሰጠው ሰዓት አልቋል!",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        content: const Text(
          "የተሰጠው ሰዓት አልቋል. እስካሁን የሰሩት ይተላለፋል።.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Consumer(builder: (context, ref, _) {
            final state = ref.watch(questionsNotifierProvider);
            return state.isSubmitting
                ? CircularProgressIndicator()
                : TextButton(
                    onPressed: () {
                      _submitAnswers();
                      // Navigator.pop(context);
                    },
                    child: const Text("OK"),
                  );
          }),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  void _submitAnswers() {
    _timer.cancel();

    widget.onFinish(
      answers.entries
          .map((e) => {
                "qid": widget.questions[e.key]["id"].toString(),
                "answer": e.value
              })
          .toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.timeLimit.inSeconds;
    _startTimer();
    controller.text = answers[currentIndex] ?? '';
  }

  void nextQuestion() {
    if (controller.text.trim().isEmpty) {
      toast("ምንም አልፃፉም!", ToastType.error, context);
      return;
    }
    if (controller.text.trim().isNotEmpty) {
      // ref
      //     .read(questionsNotifierProvider.notifier)
      //     .addOUpdateAns(currentIndex, controller.text.trim());
      answers[currentIndex] = controller.text.trim();
      widget.onSubmit({
        "qid": widget.questions[currentIndex]['id'].toString(),
        "answer": controller.text.trim(),
      });
    }

    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        controller.text = answers[currentIndex] ?? '';
      });
      // final answers = ref.read(questionsNotifierProvider).answers;
      // ref
      //     .read(questionsNotifierProvider.notifier)
      //     .addOUpdateAns(currentIndex, answers[currentIndex] ?? "");
    } else {
      widget.onFinish(answers.entries
          .map((e) => {
                "qid": widget.questions[e.key]['id'].toString(),
                "answer": e.value,
              })
          .toList());
    }
  }

  void previousQuestion() {
    if (controller.text.trim().isNotEmpty) {
      answers[currentIndex] = controller.text.trim();
      widget.onSubmit({
        "qid": widget.questions[currentIndex]['id'].toString(),
        "answer": controller.text.trim(),
      });
    }

    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        controller.text = answers[currentIndex] ?? '';
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];
    final state = ref.watch(questionsNotifierProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress bar

            LinearProgressIndicator(
              value: _remainingSeconds / widget.timeLimit.inSeconds,
              color: Colors.red,
              backgroundColor: Colors.red.shade100,
              minHeight: 6,
              borderRadius: BorderRadius.circular(30),
            ),

            Text(
              _formatTime(_remainingSeconds),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _remainingSeconds < 60 ? Colors.red : null,
              ),
            ),
            const SizedBox(height: 20),

            // Question number
            Text(
              "ጥያቄ ${currentIndex + 1} / ${widget.questions.length}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                // color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),

            // Question text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                question['question'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Answer field
            // Expanded(
            // child:
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "መልስዎን እዚህ ላይ ይጻፉ...",
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: primaryColor.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: primaryColor.shade600),
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.done,
            ),
            // ),

            const SizedBox(height: 30),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex > 0)
                  ElevatedButton.icon(
                    onPressed: previousQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    label: const Text("የበፊትቱን"),
                  )
                else
                  const SizedBox(width: 110),
                state.isSubmitting
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: CircularProgressIndicator(
                          color: whiteColor,
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: nextQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(
                          currentIndex == widget.questions.length - 1
                              ? Icons.check_circle_outline
                              : Icons.arrow_forward_ios,
                          size: 18,
                          color: whiteColor,
                        ),
                        label: Text(
                          currentIndex == widget.questions.length - 1
                              ? "አስረክብ"
                              : "ቀጣይ",
                          style: TextStyle(
                            color: whiteColor,
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
