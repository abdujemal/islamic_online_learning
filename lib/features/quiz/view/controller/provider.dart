import 'package:flutter_riverpod/flutter_riverpod.dart';
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
