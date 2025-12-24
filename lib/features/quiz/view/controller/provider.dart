import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/auth/model/streak.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/question_notifier.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/question_state.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/quiz_notifier.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/quiz_state.dart';

final quizNotifierProvider =
    StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(ref.read(quizServiceProvider), ref);
});

final quizServiceProvider = Provider<QuizService>((ref) {
  return QuizService();
});

final questionsNotifierProvider =
    StateNotifierProvider<QuestionNotifier, QuestionState>((ref) {
  return QuestionNotifier(ref.read(quizServiceProvider), ref);
});

final currentStreakProvider =
    StateNotifierProvider<StreakNotifier, StreakWNo?>((ref) {
  return StreakNotifier(ref);
});

class StreakNotifier extends StateNotifier<StreakWNo?> {
  Ref ref;
  StreakNotifier(this.ref) : super(null);

  void setStreak(StreakWNo? streakWNo) {
    if (streakWNo == null) {
      state = null;
    }
    for (Score score in streakWNo!.streak.scores) {
      ref.read(assignedCoursesNotifierProvider.notifier).addScore(score);
    }
    state = streakWNo;
  }
}
