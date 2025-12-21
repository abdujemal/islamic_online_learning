import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';
import 'package:islamic_online_learning/features/prerequisiteTest/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/question_item_shimmer.dart';
import 'package:islamic_online_learning/features/quiz/view/widget/question_list.dart';

import '../../../auth/view/pages/sign_in.dart';

class PrerequisiteTestPage extends ConsumerStatefulWidget {
  final Curriculum curr;
  const PrerequisiteTestPage({super.key, required this.curr});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PrerequisiteTestPageState();
}

class _PrerequisiteTestPageState extends ConsumerState<PrerequisiteTestPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      toast(
        "እዚህ ክፍል ለመግባት የሚከተሉትን ጥያቄዎችን መመለስ ይኖሩበታል።",
        ToastType.normal,
        context,
        isLong: true,
      );
      ref
          .read(prerequisiteTestNotifierProvider.notifier)
          .getQuizzes(widget.curr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ቅድመ ጥያቄዎች"),
      ),
      body: SafeArea(
        child: ref.watch(prerequisiteTestNotifierProvider).map(
              loading: (_) => ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) => QuestionItemShimmer(),
              ),
              loaded: (_) => MultipleQuestionQuiz(
                isPrerequisite: true,
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
                  print("i: $i \n answers: $answers");
                  final prcnt = (i / _.quizzes.length) * 100;
                  if (prcnt > 70) {
                    toast(
                      "ከ70% በላይ አምጥተዋል! ማሻአላህ!\nአሁን መዝገባውን መቀጠል ይችላሉ።",
                      ToastType.success,
                      context,
                      isLong: true,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignIn(
                          curriculumId: widget.curr.id,
                        ),
                      ),
                    );
                  } else {
                    toast(
                      "ከ70% በታች አምጥተዋል! \nእባክዎ ሌላ ክፍል ይምረጡ ና ይቀጥሉ።",
                      ToastType.error,
                      context,
                      isLong: true,
                    );
                    Navigator.pop(context);
                  }
                  return true;
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
                            .read(prerequisiteTestNotifierProvider.notifier)
                            .getQuizzes(widget.curr);
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
                            .read(prerequisiteTestNotifierProvider.notifier)
                            .getQuizzes(widget.curr);
                      },
                      icon: Icon(Icons.refresh),
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
