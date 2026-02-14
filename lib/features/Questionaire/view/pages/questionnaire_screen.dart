import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/Questionaire/model/answer_state.dart';
import 'package:islamic_online_learning/features/Questionaire/model/questionnaire.dart';
import 'package:islamic_online_learning/features/Questionaire/view/controller/provider.dart';
import 'package:islamic_online_learning/features/Questionaire/view/widget/questionWidget.dart';

class QuestionnaireScreen extends ConsumerStatefulWidget {
  final List<QuestionnaireQuestion> questions;
  const QuestionnaireScreen({super.key, required this.questions});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen> {
  final Map<String, AnswerState> answers = {};
  final Set<String> visibleQuestionIds = {};

  @override
  void initState() {
    super.initState();
    visibleQuestionIds.add(widget.questions.first.id);
  }

  void _onAnswerChanged(
    QuestionnaireQuestion question,
    AnswerState state,
  ) {
    setState(() {
      answers[question.id] = state;

      for (final condition in question.triggers) {
        if (state.selectedValue == condition.triggerValue) {
          visibleQuestionIds.add(condition.targetQuestionId);
        } else {
          visibleQuestionIds.remove(condition.targetQuestionId);
        }
      }
    });
  }

  void _submit() {
    final payload = {
      "questionnaireId": widget.questions[0].questionnaireId,
      "responses": answers.entries
          .where((e) => visibleQuestionIds.contains(e.key))
          .map((e) => e.value.toApi(e.key))
          .toList(),
    };

    debugPrint(payload.toString());
    ref.read(questionnaireNotifierProvider.notifier).submit(payload, context);
  }

  @override
  Widget build(BuildContext context) {
    final visibleQuestions = widget.questions
        .where((q) => visibleQuestionIds.contains(q.id))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("ዳሰሳ ጥናት")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...visibleQuestions.map((q) => QuestionWidget(
                question: q,
                onChanged: (state) => _onAnswerChanged(q, state),
              )),
          const SizedBox(height: 24),
          Consumer(builder: (context, ref, _) {
            final state = ref.watch(questionnaireNotifierProvider);
            return ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
              ),
              child: state.isSubmitting
                  ? CircularProgressIndicator( color: whiteColor,)
                  : const Text("አስረክብ"),
            );
          })
        ],
      ),
    );
  }
}
