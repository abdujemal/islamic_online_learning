import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/core/lib/timezone_handler.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';
import 'package:islamic_online_learning/features/auth/service/auth_service.dart';
import 'package:islamic_online_learning/features/auth/view/controller/register_state.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/main_page.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class RegisterNotifier extends StateNotifier<RegisterState> {
  final AuthService authService;
  final Ref ref;
  RegisterNotifier(this.authService, this.ref) : super(RegisterState());

  void setToDefault() {
    state = state.copyWith(
      isLoadingGroups: false,
      isAddingNewGroup: false,
    );
  }

  void toggleAddingGroup() {
    state = state.copyWith(
      isAddingNewGroup: !state.isAddingNewGroup,
    );
  }

  Future<void> getGroups(
    int age,
    String gender,
    BuildContext context,
  ) async {
    try {
      state = state.copyWith(
        isLoadingGroups: true,
      );
      final timeZone = await getDeviceTimeZone();

      final pref = await ref.read(sharedPrefProvider);
      final curriculumId = pref.getString("curriculumId");

      if (curriculumId == null) {
        throw Exception("curriculumId is null");
      }

      final groups =
          await authService.fetchGroups(age, gender, timeZone, curriculumId);
      state = state.copyWith(
        isLoadingGroups: false,
        groups: groups,
      );
    }on ConnectivityException catch (err) {
      state = state.copyWith(isLoadingGroups: false, error: err.toString());
      toast(err.message, ToastType.error, context);
    } catch (err) {
      print(err);
      toast("ቡድኖችን ማምጣት አልተሳካም።", ToastType.error, context);
      state = state.copyWith(
        isLoadingGroups: false,
      );
    }
  }

  Future<void> register(
    int age,
    String name,
    String gender,
    String discussionTime,
    String discussionDay,
    String? groupId,
    List<String> pl,
    BuildContext context,
    WidgetRef ref,
  ) async {
    final pref = await ref.read(sharedPrefProvider);
    final otpId = pref.getString(PrefConsts.otpId);
    final curriculumId = pref.getString(PrefConsts.curriculumId);
    final dob = DateTime.now().subtract(Duration(days: 365 * age)).toString();
    final timeZone = await getDeviceTimeZone();

    UserInput userInput = UserInput(
      name: name,
      dob: dob,
      gender: gender,
      previousLearning: pl,
      discussionTime: discussionTime,
      discussionDay: discussionDay,
      otpId: otpId!,
      curriculumId: curriculumId!,
      groupId: groupId,
      timeZone: timeZone,
    );
    try {
      state = state.copyWith(isSaving: true);
      await authService.register(userInput);
      final pref = await ref.read(sharedPrefProvider);
      // pref.setString(PrefConsts.token, "Bearer $token");
      pref.remove(PrefConsts.otpId);
      state = state.copyWith(isSaving: false);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MainPage(),
        ),
        (v) => false,
      );
    } on ConnectivityException catch (err) {
      state = state.copyWith(isSaving: false, error: err.toString());
      toast(err.message, ToastType.error, context);
    } catch (err) {
      print("Error: ${err.toString()}");
      state = state.copyWith(isSaving: false, error: err.toString());
      toast("መመዝገብ አልተሳካም።", ToastType.error, context);
    }
  }
}
