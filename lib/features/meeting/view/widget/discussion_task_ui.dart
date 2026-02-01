import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/question_list.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/short_answer_quiz.dart';
import 'package:islamic_online_learning/features/meeting/view/controller/voice_room/voice_room_notifier.dart';
import 'package:islamic_online_learning/features/meeting/view/controller/voice_room/voice_room_state.dart';

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
      return Expanded(
        child: Column(
          children: [
            Center(
              child: Text(
                "አሰላሙ አለይኩም ውራህመቱላሂ ወበረካቱሁ",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "ኢንሻአላህ ለ5 ደቂቃ ያክል በዚህ ሳምንት የተማራቹትን ትወያያላችሁ።",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Center(
              child: Text(
                "የመወያያ ርእሶች",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: topics == null
                  ? CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: topics
                            .map((e) => Text(
                                  e,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
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
            child: Text("ምንም ጥያቄ የለም. ውይይቱን ቀጥሉ."),
          );
        } else {
          return SingleChildScrollView(
            child: MultipleQuestionQuiz(
              fromDiscussion: true,
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
              onSubmit: (qa) {
                // print(qa);
                ref
                    .read(voiceRoomNotifierProvider.notifier)
                    .submitAnswerForQuiz(
                      ref,
                      QuizAns(
                        quizId: qa["qid"]!,
                        answer: int.parse(qa["answer"]!),
                      ),
                    );
              },
              onFinish: (i, answers) async {
                // await Future.delayed(Duration(seconds: 1));
                ref
                    .read(voiceRoomNotifierProvider.notifier)
                    .changeVoiceRoomStatus(VoiceRoomStatus.choiceDone);
                toast(
                    "You have finished the Multiple Choice questions. Please wait for the countdown to end.",
                    ToastType.success,
                    context,
                    isLong: true);
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
      if (voiceRoomState.timer == null) {
        return SizedBox();
      }
      final questions = ref.watch(discussionQuestionsProvider);
      if (voiceRoomState.givenTime == null) return SizedBox();
      // final discussionSeconds = voiceRoomState.givenTime!.segments.assignment >
      //         voiceRoomState.discussionSec
      //     ? voiceRoomState.discussionSec
      //     : voiceRoomState.givenTime!.segments.assignment;
      if (questions == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (questions.isEmpty) {
        return Center(
          child: Text("No questions"),
        );
      }
      return Expanded(
        child: SingleChildScrollView(
          child: ShortAnswerQuiz(
            // timeLimit: Duration(
            //   seconds: discussionSeconds,
            // ),
            fromDiscussion: true,
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
              ref
                  .read(voiceRoomNotifierProvider.notifier)
                  .submitAnswerForQuestion(
                    ref,
                    QA(
                      questionId: answer["qid"]!,
                      answer: answer["answer"]!,
                    ),
                  );
            },
            onFinish: (answers) async {
              print("answers: $answers");
              ref
                  .read(voiceRoomNotifierProvider.notifier)
                  .changeVoiceRoomStatus(VoiceRoomStatus.shortDone);
              toast(
                  "You have finished the short answer Questions. Please wait for the countdown to end.",
                  ToastType.success,
                  context,
                  isLong: true);
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
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final voiceRoomState = ref.watch(voiceRoomNotifierProvider);
    return Column(
      children: [
        // Text(
        //   widget.status.toString(),
        //   style: const TextStyle(
        //     color: Colors.tealAccent,
        //   ),
        // ),
        // if (widget.status == VoiceRoomStatus.end)

        // else
        if (widget.status == VoiceRoomStatus.discussing)
          _buildDiscussionUI()

        else if (widget.status == VoiceRoomStatus.choice)
          _buildChoiceUI()
        else if(widget.status == VoiceRoomStatus.choiceDone)
          Expanded( 
            child: Center(
              child: Text(
                //give me islamic motivational text
                "ማሻአላህ! የምርጫውን ክፍል አጠናቀዋል። በትዕግስት ይቆዩ እና ለሚቀጥለው ይዘጋጁ።",
                // "You have finished the Choice part. Please wait for the next part.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          )
        else if (widget.status == VoiceRoomStatus.short)
          _buildShortAnswerUI(voiceRoomState)
        else if (widget.status == VoiceRoomStatus.shortDone)
          Expanded( 
            child: Center(
              child: Text(
                "ማሻአላህ! የጥያቄዎቹን አጠናቀዋል። ደቂቃው እስኪያልቅ በትዕግስት ይጠብቁ።",
                
                // "You have finished the Short answer part. Please wait for the next part.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          )
      ],
    );
  }
}
