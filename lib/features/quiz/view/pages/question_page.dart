import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/already_submitted_screen.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/question_item_shimmer.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/short_answer_quiz.dart';

class QuestionPage extends ConsumerStatefulWidget {
  // final Lesson lesson;
  const QuestionPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionPageState();
}

class _QuestionPageState extends ConsumerState<QuestionPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // PlaylistHelper.audioPlayer.stop();
      ref.read(questionsNotifierProvider.notifier).getTestQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ጥያቄዎች"),
      ),
      body: ref.watch(questionsNotifierProvider).map(
            loading: (_) => ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) => QuestionItemShimmer(),
            ),
            loaded: (_) => ShortAnswerQuiz(
              questions: _.questions
                  .map(
                    (q) => {
                      "id": q.id,
                      "question": q.question,
                    },
                  )
                  .toList(),
              onFinish: (answers) async {
                print("answers: $answers");
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
            empty: (_) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ምንም የለም"),
                  IconButton(
                    onPressed: () async {
                      await ref
                          .read(questionsNotifierProvider.notifier)
                          .getTestQuestion();
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
                          .read(questionsNotifierProvider.notifier)
                          .getTestQuestion();
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
