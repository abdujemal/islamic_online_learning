import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/Questionaire/view/controller/questionnaire_state.dart';
import 'package:islamic_online_learning/features/auth/service/auth_service.dart';

class QuestionnaireNotifier extends StateNotifier<QuestionnaireState> {
  final AuthService authService;
  final Ref ref;
  QuestionnaireNotifier(this.authService, this.ref)
      : super(QuestionnaireState());

  Future<void> submit(Map<String, dynamic> data, BuildContext context) async {
    try {
      state = state.copyWith(isSubmitting: true);
      await authService.submitQuestionnaire(data);
      toast("ሃሳብዎን ስለ ሰጡን እናመሰግናለን!", ToastType.success, context);
      state = state.copyWith(isSubmitting: false);
      Navigator.pop(context);
    } catch (err) {
      String errMsg = getErrorMsg(err.toString(), "ማስረከብ አልተቻለም!");
      state = state.copyWith(isSubmitting: false);
      handleError(err.toString(), context, this.ref, () {
        toast(errMsg, ToastType.error, context);
        print(err);
      });
    }
  }

  Future<void> submitFeedback(
      String text, int? lessonNum, BuildContext context) async {
    try {
      state = state.copyWith(isSubmitting: true);
      await authService.submitFeedback(text, lessonNum);
      toast("ሃሳብዎን ስለ ሰጡን እናመሰግናለን!", ToastType.success, context);
      state = state.copyWith(isSubmitting: false);
      Navigator.pop(context);
    } catch (err) {
      String errMsg = getErrorMsg(err.toString(), "ማስረከብ አልተቻለም!");
      state = state.copyWith(isSubmitting: false);
      handleError(err.toString(), context, this.ref, () {
        toast(errMsg, ToastType.error, context);
        print(err);
      });
    }
  }
}
