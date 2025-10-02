import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
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

  Future<bool> checkIfTheCourseStarted(BuildContext context) async {
    await getMyInfo(context);
    if (state.user?.group.startDate != null) {
      state = state.copyWith(courseStarted: true);
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
