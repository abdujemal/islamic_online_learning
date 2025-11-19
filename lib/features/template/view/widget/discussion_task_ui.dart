import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/question_list.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/short_answer_quiz.dart';
import 'package:islamic_online_learning/features/template/view/controller/voice_room/voice_room_notifier.dart';
import 'package:islamic_online_learning/features/template/view/controller/voice_room/voice_room_state.dart';

class DiscussionTaskUi extends ConsumerStatefulWidget {
  final VoiceRoomStatus status;
  const DiscussionTaskUi({super.key, required this.status});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DiscussionTaskUiState();
}

class _DiscussionTaskUiState extends ConsumerState<DiscussionTaskUi> {
  Widget _buildDiscussionUI() {
    return Consumer(builder: (context, ref, _) {
      final topics = ref.watch(discussionTopicsProvider);
      return Column(
        children: [
          Center(
            child: Text(
              "Discussion Phase",
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          Expanded(
            child: topics == null
                ? CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                      children: topics.map((e) => Text(e)).toList(),
                    ),
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildChoiceUI() {
    return Expanded(
      child: Consumer(builder: (context, ref, _) {
        final quizzes = ref.watch(discussionQuizzesProvider);
        if (quizzes == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (quizzes.isEmpty) {
          return Center(
            child: Text("No quizzes available. continue discussion."),
          );
        } else {
          return SingleChildScrollView(
            child: MultipleQuestionQuiz(
              questions: quizzes
                  .map(
                    (q) => QuestionModel(
                      id: q.id,
                      question: q.question,
                      options: q.options
                          .map(
                            (e) => QuestionOption(
                              id: "${q.options.indexOf(e)}",
                              text: e,
                              isCorrect: q.options.indexOf(e) == q.answer,
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
              onFinish: (i, answers) async {
                await Future.delayed(Duration(seconds: 1));
                return true;
                // print("i: $i, answers: $answers");
                // List<String> quizAnswers = [];
                // for (var ans in answers.entries) {
                //   quizAnswers.add("${ans.key}:${ans.value.join("")}");
                // }
                // await ref.read(quizNotifierProvider.notifier).submitQuestions(
                //       widget.lesson,
                //       quizAnswers,
                //       ref,
                //     );
                // if (ref.read(quizNotifierProvider).submittingError != null) {
                //   return false;
                // } else {
                //   return true;
                // }
              },
            ),
          );
        }
      }),
    );
  }

  Widget _buildShortAnswerUI(VoiceRoomState voiceRoomState) {
    return Consumer(builder: (context, ref, _) {
      final questions = ref.watch(discussionQuestionsProvider);
      if (questions == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return ShortAnswerQuiz(
        timeLimit: Duration(
          seconds: voiceRoomState.givenTime?.segments.assignment ?? 10 * 60,
        ),
        questions: questions
            .map(
              (q) => {
                "id": q.id,
                "question": q.question,
              },
            )
            .toList(),
        onSubmit: (answer) {
          print(answer);
          ref.read(questionsNotifierProvider.notifier).addOUpdateAns(
                QA(
                  questionId: answer["qid"]!,
                  answer: answer["answer"]!,
                ),
              );
        },
        onFinish: (answers) async {
          print("answers: $answers");
          // await ref.read(questionsNotifierProvider.notifier).submitTest(context);
          // setState(() {
          //   canPop = true;
          // });
          // Navigator.pop(context);

          // List<String> quizAnswers = [];
          // for (var ans in answers) {
          //   quizAnswers.add("${ans.key}:${ans.value.join("")}");
          // }
          // await ref.read(quizNotifierProvider.notifier).submitQuestions(
          //       widget.lesson,
          //       quizAnswers,
          //       ref,
          //     );
          // if (ref.read(quizNotifierProvider).submittingError != null) {
          //   return false;
          // } else {
          //   return true;
          // }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final voiceRoomState = ref.watch(voiceRoomNotifierProvider);
    return Column(
      children: [
        Text(
          widget.status.toString(),
          style: const TextStyle(
            color: Colors.tealAccent,
          ),
        ),
        if (widget.status == VoiceRoomStatus.discussing)
          _buildDiscussionUI()
        else if (widget.status == VoiceRoomStatus.choice)
          _buildChoiceUI()
        else if (widget.status == VoiceRoomStatus.short)
          _buildShortAnswerUI(voiceRoomState),
      ],
    );
  }
}
