import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/already_submitted_screen.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/question_item_shimmer.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/short_answer_quiz.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/test_intro_page.dart';

class QuestionPage extends ConsumerStatefulWidget {
  final String testTitle;
  const QuestionPage(this.testTitle, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionPageState();
}

class _QuestionPageState extends ConsumerState<QuestionPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // PlaylistHelper.audioPlayer.stop();
      ref
          .read(questionsNotifierProvider.notifier)
          .getTestQuestion(context)
          .then((v) {
        final state = ref.read(questionsNotifierProvider);

        if (state.questions.isNotEmpty &&
            state.error == null &&
            !state.isLoading) {}
      });
    });
  }

  bool canPop = false;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          ref.read(questionsNotifierProvider.notifier).setupToDefault();
        } else {
          final state = ref.read(questionsNotifierProvider);
          if (state.questions.isNotEmpty &&
              state.testAttempt != null &&
              !state.isLoading) {
            final res = await ref
                .read(questionsNotifierProvider.notifier)
                .showExitQuizDialog(
                  context: context,
                  onSubmit: () async {
                    await ref
                        .read(questionsNotifierProvider.notifier)
                        .submitTest(context);
                    setState(() {
                      canPop = true;
                    });
                    Navigator.pop(context);
                  },
                );
            if (res) {}
          } else {
            setState(() {
              canPop = true;
            });
            Navigator.pop(context);
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("ፈተና"),
          ),
          body: ref.watch(questionsNotifierProvider).map(
                loading: (_) => ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) => QuestionItemShimmer(),
                ),
                testStarted: (_) => ShortAnswerQuiz(
                  timeLimit: Duration(minutes: _.givenTime!),
                  questions: _.questions
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
                    await ref
                        .read(questionsNotifierProvider.notifier)
                        .submitTest(context);
                    setState(() {
                      canPop = true;
                    });
                    Navigator.pop(context);
        
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
                loaded: (_) => TestIntroPage(
                  testTitle: widget.testTitle,
                  duration: "${_.givenTime ?? "..."}",
                  unfinishedTest: _.isThereUnfinishedTest,
                  rules: [
                    "የተሰጠዎት ጊዜ ካለቀ ምንም ጥያቄ መስራት ስለማይችሉ፤ እባክዎ ጊዜዎን ባግባቡ ይጠቀሙ።",
                    "ፈተናውን ከጀመሩ ቡሃላ ወደ ሃላ ከተመለሱ ወይም ወደ ከአፑ ከወጡ፤ ድጋሚ ተመልሰው መፈተን ስለማይችሉ፤ ፈተናውን ከጀመሩ እስኪ ጨርሱ ድረስ ከአፑ እንዳይወጡ።"
                  ],
                  onStart: () {
                    ref
                        .read(questionsNotifierProvider.notifier)
                        .startTest(widget.testTitle, context);
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
                              .getTestQuestion(context);
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
                              .getTestQuestion(context);
                        },
                        icon: Icon(Icons.refresh),
                      )
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
