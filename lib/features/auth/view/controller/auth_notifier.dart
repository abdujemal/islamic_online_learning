import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/model/course_related_data.dart';
import 'package:islamic_online_learning/features/auth/service/auth_service.dart';
import 'package:islamic_online_learning/features/auth/view/controller/auth_state.dart';
import 'package:islamic_online_learning/features/auth/view/pages/register_page.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;
  final Ref ref;
  AuthNotifier(this.authService, this.ref) : super(AuthState());

  Future<void> getMyInfo(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final user = await authService.getMyInfo();
      await getScores();
      state = state.copyWith(isLoading: false, user: user);
    } on ConnectivityException catch (err) {
      state = state.copyWith(isLoading: false, error: err.toString());
      // toast(err.message, ToastType.error, context);
    } catch (err) {
      print("Error: $err");
      // toast("የእርስዎን መለያ ማግኘት አልተቻለም።", ToastType.error, context);
      state =
          state.copyWith(isLoading: false, error: "የእርስዎን መለያ ማግኘት አልተቻለም።");
    }
  }

  Future<void> getScores() async {
    try {
      final scores = await authService.getScores();
      state = state.copyWith(scores: scores);
    } catch (err) {
      print("Could not get scores");
      print("err: ${err.toString()}");
    }
  }

  void setCourseRelatedData(CourseRelatedData data) async {
    print("Setting course related data: $data");
    state = state.copyWith(courseRelatedData: data);
  }

  Future<bool?> hasCourseStarted() async {
    try {
      final yes = await authService.hasCourseStarted();
      return yes;
    } catch (err) {
      print("Could not get course data");
      print("err: ${err.toString()}");
      return null;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(user: null);
  }

  Future<bool> checkIfTheCourseStarted(WidgetRef ref) async {
    getMyInfo(ref.context);
    final started = await hasCourseStarted();
    if (started == true) {
      state = state.copyWith(courseStarted: true);
      ref.read(assignedCoursesNotifierProvider.notifier).getCurriculum(ref);
      return true;
    } else {
      return false;
    }
  }

  void unfinishedRegistration(String? otpId, BuildContext context,
      {bool signedIn = false}) {
    if (signedIn) return;
    if (otpId != null) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => RegisterPage(
              otpId: otpId,
            ),
          ),
          (v) => false,
        );
      }
    } else {
      ref.read(curriculumNotifierProvider.notifier).getCurriculums();
    }
  }
}
