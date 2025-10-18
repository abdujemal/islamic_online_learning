import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';
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
      ref.read(quizNotifierProvider.notifier).getQuizzes(widget.lesson.id);
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
                      id: q.question,
                      question: q.question,
                      options: q.options
                          .map(
                            (e) => QuestionOption(
                              id: "${_.quizzes.indexOf(q)}-${q.options.indexOf(e)}",
                              text: e,
                              isCorrect: q.options.indexOf(e) == q.answer,
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
              onFinish: (i, answers) {
                print("i: $i, answers: $answers");
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
                          .getQuizzes(widget.lesson.id);
                    },
                    icon: Icon(Icons.refresh),
                  )
                ],
              ),
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
                          .getQuizzes(widget.lesson.id);
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
