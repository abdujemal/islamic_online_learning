import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/question_state.dart';

class QuestionNotifier extends StateNotifier<QuestionState> {
  final QuizService quizService;
  QuestionNotifier(this.quizService) : super(QuestionState());

  Future<void> getTestQuestion() async {
    try {
      state = state.copyWith(isLoading: true);
      final quizzes = await quizService.getTestQuestions();
      final givenMinute = await quizService.getGivenMinute();
      final isThereUnfinishedTest = await quizService.isThereUnfinishedTest();

      state = state.copyWith(
        isLoading: false,
        questions: quizzes,
        givenTime: givenMinute,
        isThereUnfinishedTest: isThereUnfinishedTest,
      );
    } catch (err) {
      state = state.copyWith(isLoading: false, error: "ጥያቄዎቹን ማግኘት አልተቻለም!");
      print(err);
    }
  }

  void setupToDefault() {
    state = QuestionState(
      initial: true,
      isLoading: false,
      submitted: false,
      isSubmitting: false,
      isThereUnfinishedTest: false,
      questions: const [],
      givenTime: null,
      error: null,
      testAttempt: null,
      submittingError: null,
    );
  }

  Future<void> startTest(String title) async {
    try {
      state = state.copyWith(isLoading: true);
      final testAttempt = await quizService.addTestAttempt(title);

      state = state.copyWith(isLoading: false, testAttempt: testAttempt);
    } catch (err) {
      state = state.copyWith(isLoading: false, error: "ፈተናውን መጀመር አልተቻለም!");
      print(err);
    }
  }

  void addOUpdateAns(QA qa) {
    state = state.copyWith(answers: [...state.answers, qa]);
  }

  Future<void> submitTest(BuildContext context) async {
    try {
      state = state.copyWith(isSubmitting: true);
      // final streak =
      await quizService.submitTest(state.testAttempt!.id, state.answers);

      state = state.copyWith(
        isSubmitting: false,
      );
      toast("ማሻአላህ! ፈተናዎን በተሳካ ሁኔታ ተረክበናል፤ ኢንሻአላህ በ24 ሰዓት ውስጥ ኡስታዞቻችን ያርሙታል።",
          ToastType.success, context,
          isLong: true);
    } catch (err) {
      state = state.copyWith(isSubmitting: false);
      toast("ፈተናውን ማስረከብ አልተቻለም!", ToastType.error, context);
      print(err);
    }
  }

  Future<bool> showExitQuizDialog(
      {required BuildContext context,
      required Future<void> Function() onSubmit}) async {
    bool shouldExit = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).cardColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.orange, size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    "ፈተናውን ማቋረጥ ይፈልጋሉ?",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "ፈተናውን ካቋረጡ እስካሁን የመለሱት ይመዘገባል፤ ግን ሌላ ጊዜ ፈተናውን መጨረስ አይችሉም!\nማቋረጥ ይፈልጋሉ?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          shouldExit = false;
                        },
                        icon: const Icon(Icons.cancel, color: Colors.white),
                        label: const Text("አይ",
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade500,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                      Consumer(builder: (context, ref, _) {
                        final state = ref.watch(questionsNotifierProvider);
                        return state.isSubmitting
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: CircularProgressIndicator(
                                  color: whiteColor,
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: () async {
                                  await onSubmit();
                                  Navigator.of(context).pop();
                                  shouldExit = true;
                                  // onSubmitPartial();
                                },
                                icon: const Icon(Icons.logout,
                                    color: Colors.white),
                                label: const Text("መዝግብ ና ውጣ",
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                ),
                              );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return shouldExit;
  }
}
