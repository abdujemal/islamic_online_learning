import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/Questionaire/view/controller/provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  final int? lessonNum;
  const FeedbackScreen({super.key, required this.lessonNum});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  TextEditingController feedbackTc = TextEditingController();

  _submit() {
    if (feedbackTc.text.trim().isEmpty) {
      return;
    }
    ref.read(questionnaireNotifierProvider.notifier).submitFeedback(
          feedbackTc.text.trim(),
          widget.lessonNum,
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("አስተያየት መስጫ"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(13),
            child: TextField(
              controller: feedbackTc,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
              maxLines: 4,
            ),
          ),
          const SizedBox(height: 16),
          Consumer(builder: (context, ref, _) {
            final state = ref.watch(questionnaireNotifierProvider);
            return ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
              ),
              child: state.isSubmitting
                  ? CircularProgressIndicator(
                      color: whiteColor,
                    )
                  : const Text("አስረክብ"),
            );
          })
        ],
      ),
    );
  }
}
