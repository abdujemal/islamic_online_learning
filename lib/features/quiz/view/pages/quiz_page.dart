import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/playlist_helper.dart';
// import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/already_submitted_screen.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/question_item_shimmer.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/question_list.dart';

class QuizPage extends ConsumerStatefulWidget {
  final Lesson lesson;
  const QuizPage(this.lesson, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      PlaylistHelper.audioPlayer.stop();
      ref
          .read(quizNotifierProvider.notifier)
          .getQuizzes(widget.lesson.id, context);
    });
  }

  void stateListener(v, y) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ጥያቄዎች"),
      ),
      body: ref.watch(quizNotifierProvider).map(
            loading: (_) => ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) => QuestionItemShimmer(),
            ),
            loaded: (_) => MultipleQuestionQuiz(
              questions: _.quizzes
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
                print("i: $i, answers: $answers");
                List<String> quizAnswers = [];
                for (var ans in answers.entries) {
                  quizAnswers.add("${ans.key}:${ans.value.join("")}");
                }
                await ref.read(quizNotifierProvider.notifier).submitQuestions(
                      widget.lesson,
                      quizAnswers,
                      ref,
                    );
                if (ref.read(quizNotifierProvider).submittingError != null) {
                  return false;
                } else {
                  return true;
                }
              },
            ),
            empty: (_) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ምንም የለም"),
                  IconButton(
                    onPressed: () async {
                      await ref
                          .read(quizNotifierProvider.notifier)
                          .getQuizzes(widget.lesson.id, context);
                    },
                    icon: Icon(Icons.refresh),
                  )
                ],
              ),
            ),
            submittedW: (_) => AlreadySubmittedScreen(
              onBack: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainPage(),
                  ),
                  (_) => false,
                );
              },
            ),
            error: (_) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _.error ?? "",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await ref
                          .read(quizNotifierProvider.notifier)
                          .getQuizzes(widget.lesson.id, context);
                    },
                    icon: Icon(Icons.refresh),
                  )
                ],
              ),
            ),
          ),
    );
  }
}
