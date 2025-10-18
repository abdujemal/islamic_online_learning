import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/quiz_notifier.dart';
import 'package:islamic_online_learning/features/quiz/view/controller/quiz_state.dart';

final quizNotifierProvider =
    StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier(ref.read(quizServiceProvider));
});

final quizServiceProvider = Provider<QuizService>((ref) {
  return QuizService();
});
