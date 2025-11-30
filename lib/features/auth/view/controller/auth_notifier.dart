import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/model/course_related_data.dart';
import 'package:islamic_online_learning/features/auth/model/streak.dart';
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
      await getScores(context);
      await _checkIfTheCourseStarted(context);
      state = state.copyWith(isLoading: false, user: user);
    } on ConnectivityException catch (err) {
      state = state.copyWith(isLoading: false, error: err.toString());
      // toast(err.message, ToastType.error, context);
    } catch (err) {
      // toast("የእርስዎን መለያ ማግኘት አልተቻለም።", ToastType.error, context);
      handleError(
        err.toString(),
        context,
        ref,
        () async {
          print("Error: $err");
          final token = await getAccessToken();
          state = state.copyWith(
            isLoading: false,
            error: getErrorMsg(err.toString(), "የእርስዎን መለያ ማግኘት አልተቻለም።"),
            tokenIsNull: token == null,
          );
        },
      );
    }
  }

  Future<void> updateMyInfo(BuildContext context, String name, int age) async {
    try {
      state = state.copyWith(isUpdating: true);
      final user = await authService.updateMyInfo(name, age);
      // await getScores(context);
      // await _checkIfTheCourseStarted(context);
      state = state.copyWith(isUpdating: false, user: user);
      Navigator.pop(context);
    } on ConnectivityException catch (err) {
      state = state.copyWith(isUpdating: false, error: err.toString());
      // toast(err.message, ToastType.error, context);
    } catch (err) {
      // toast("የእርስዎን መለያ ማግኘት አልተቻለም።", ToastType.error, context);
      handleError(
        err.toString(),
        context,
        ref,
        () async {
          print("Error: $err");
          final token = await getAccessToken();
          toast(
            getErrorMsg(err.toString(), "መለያዎን ማደስ አልተቻለም!"),
            ToastType.error,
            context,
          );
          state = state.copyWith(
            isUpdating: false,
            // error: getErrorMsg(err.toString(), "የእርስዎን መለያ ማግኘት አልተቻለም።"),
            tokenIsNull: token == null,
          );
        },
      );
    }
  }

  Future<void> getScores(BuildContext context) async {
    final scores = await authService.getScores();
    state = state.copyWith(scores: scores);
  }

  void setCourseRelatedData(CourseRelatedData data) async {
    // print("Setting course related data: $data");
    state = state.copyWith(courseRelatedData: data);
  }

  Future<bool?> hasCourseStarted() async {
    // try {
    final yes = await authService.hasCourseStarted();
    return yes;
    // } catch (err) {
    //   print("Could not get course data");
    //   print("err: ${err.toString()}");
    //   throw Exception("Could not get course data");
    // }
  }

  Future<void> logout() async {
    await deleteTokens();
    ref.read(curriculumNotifierProvider.notifier).getCurriculums();
    setUserNull();
  }

  void setUserNull() {
    state = state.copyWith(user: null, tokenIsNull: true);
  }

  Future<void> _checkIfTheCourseStarted(BuildContext context) async {
    // getMyInfo(ref.context);
    ref.read(assignedCoursesNotifierProvider.notifier).getCurriculum(context);
    // try {
    //   final started = await hasCourseStarted();
    //   if (started == true) {
    //     state = state.copyWith(courseStarted: true);
    //     return true;
    //   } else {
    //     return false;
    //   }
    // } catch (err) {
    //   return false;
    // }
  }

  Future<List<DateTime>> getStreakFor(
      int year, int month, BuildContext context) async {
    try {
      final streaks = await authService.getStreakFor(month, year);
      return streaks;
    } catch (err) {
      handleError(err.toString(), context, ref, () {
        toast(getErrorMsg(err.toString(), "ማግኘት አልተቻለም!"), ToastType.error,
            context);
      });
      return [];
    }
  }

  void setCourseStarted(CourseStarted v) {
    state = state.copyWith(courseStarted: v);
  }

  void unfinishedRegistration(
    String otpId,
    BuildContext context,
  ) {
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
  }
}
