import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/features/auth/service/auth_service.dart';
import 'package:islamic_online_learning/features/auth/view/controller/sign_in_state.dart';
import 'package:islamic_online_learning/features/auth/view/pages/register_page.dart';
import 'package:islamic_online_learning/features/auth/view/pages/verify_otp_page.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class SignInNotifier extends StateNotifier<SignInState> {
  final AuthService authService;
  final Ref ref;
  SignInNotifier(this.authService, this.ref) : super(SignInState());

  void toggleMode() {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(isPhoneMode: !state.isPhoneMode);
  }

  Future<void> sendOtp(
    String phone,
    String? curriculumId,
    BuildContext context,
  ) async {
    if (curriculumId != null) {
      final pref = await ref.read(sharedPrefProvider);
      pref.setString(PrefConsts.curriculumId, curriculumId);
    }

    try {
      state = state.copyWith(isLoading: true);
      await authService.sendOtpRequest(phone);
      state = state.copyWith(isLoading: false);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyOtpPage(
              phone: phone,
            ),
          ),
        );
      }
    }on ConnectivityException catch (err) {
      state = state.copyWith(isLoading: false, error: err.toString());
      toast(err.message, ToastType.error, context);
    } catch (err) {
      print("Error: $err");
      toast("ኮድ በመላክ ላይ ሳለ ስህተት ተከስቷል።", ToastType.error, context);
      state = state.copyWith(isLoading: false, error: err.toString());
    }
  }

  Future<void> verifyOtp(String phone, String otp, BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);
      final data = await authService.verifyOtpRequest(phone, otp);
      final pref = await ref.read(sharedPrefProvider);
      print("Data: ${data.toString()}");
      if (data["otp"] != null) {
        pref.setString(PrefConsts.otpId, data["otp"]["id"] as String);
        state = state.copyWith(isLoading: false);

        // if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => RegisterPage(
              otpId: data["otp"]["id"],
            ),
          ),
          (route) => false,
        );
        // }
      } else {
        pref.setString(PrefConsts.token, "Bearer ${data["token"] as String}");
        state = state.copyWith(isLoading: false);

        // if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
          (route) => false,
        );
        // }
      }
    }on ConnectivityException catch (err) {
      state = state.copyWith(isLoading: false, error: err.toString());
      toast(err.message, ToastType.error, context);
    } catch (err) {
      state = state.copyWith(
        isLoading: false,
        error: err.toString(),
      );
      print(err.toString());
      toast(err.toString(), ToastType.error, context);
    }
  }
}
