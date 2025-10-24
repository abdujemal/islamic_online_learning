import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/constants.dart';

class ShortAnswerQuiz extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final Function(List<Map<String, String>>) onFinish;

  const ShortAnswerQuiz({
    super.key,
    required this.questions,
    required this.onFinish,
  });

  @override
  State<ShortAnswerQuiz> createState() => _ShortAnswerQuizState();
}

class _ShortAnswerQuizState extends State<ShortAnswerQuiz> {
  int currentIndex = 0;
  final Map<int, String> answers = {};
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = answers[currentIndex] ?? '';
  }

  void nextQuestion() {
    if (controller.text.trim().isEmpty) {
      toast("ምንም አልፃፉም!", ToastType.error, context);
      return;
    }
    if (controller.text.trim().isNotEmpty) {
      answers[currentIndex] = controller.text.trim();
    }

    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        controller.text = answers[currentIndex] ?? '';
      });
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
    }

    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        controller.text = answers[currentIndex] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentIndex];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: (currentIndex + 1) / widget.questions.length,
              color: primaryColor,
              backgroundColor: primaryColor.shade100,
              minHeight: 6,
            ),
            const SizedBox(height: 20),

            // Question number
            Text(
              "ጥያቄ ${currentIndex + 1} / ${widget.questions.length}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 10),

            // Question text
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
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
                hintText: "Write your answer here...",
                filled: true,
                fillColor: Colors.white,
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
                    label: const Text("Previous"),
                  )
                else
                  const SizedBox(width: 110),
                ElevatedButton.icon(
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
                        ? "Finish"
                        : "Next",
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
