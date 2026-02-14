import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/Questionaire/view/controller/questionnaire_notifier.dart';
import 'package:islamic_online_learning/features/Questionaire/view/controller/questionnaire_state.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';

final questionnaireNotifierProvider =
    StateNotifierProvider<QuestionnaireNotifier, QuestionnaireState>(
  (ref) {
    return QuestionnaireNotifier(ref.read(authServiceProvider), ref);
  },
);
