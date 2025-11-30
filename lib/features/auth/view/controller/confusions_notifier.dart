import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/service/auth_service.dart';
import 'package:islamic_online_learning/features/auth/view/controller/confusions_state.dart';

class ConfusionsNotifier extends StateNotifier<ConfusionsState> {
  final Ref ref;
  final AuthService service;
  ConfusionsNotifier(this.service, this.ref) : super(ConfusionsState());

  Future<void> getConfusions(BuildContext context,
      {bool loadMore = false}) async {
    if (state.isLoadingMore) return;
    if (loadMore) {
      if (state.hasNoMore) return;
      state = state.copyWith(page: state.page + 1);
    } else {
      state = state.copyWith(page: 1);
    }
    try {
      if (!loadMore) {
        state = state.copyWith(isLoading: true);
      } else {
        state = state.copyWith(isLoadingMore: true);
      }
      final confusions = await service.getConfusions(state.page);
      // print(confusions);
      if (!loadMore) {
        state = state.copyWith(
          isLoading: false,
          confusions: confusions,
        );
      } else {
        state = state.copyWith(
          isLoadingMore: false,
          hasNoMore: confusions.isEmpty,
          confusions: [
            ...state.confusions,
            ...confusions,
          ],
        );
      }
    } on ConnectivityException catch (err) {
      // toast(err.message, ToastType.error, context)
      if (!loadMore) {
        state = state.copyWith(
          isLoading: false,
          error: err.message,
        );
      } else {
        state = state.copyWith(
          isLoadingMore: false,
        );
        toast(err.message, ToastType.error, context);
      }
    } catch (e) {
      final errorMsg = getErrorMsg(
        e.toString(),
        "ክፍሎች ማግኘት አልተቻለም።",
      );
      handleError(
        e.toString(),
        context,
        ref,
        () async {
          print("Error: $e");
          if (!loadMore) {
            state = state.copyWith(
              isLoading: false,
              error: errorMsg,
            );
          } else {
            state = state.copyWith(
              isLoadingMore: false,
            );
            toast(errorMsg, ToastType.error, context);
          }
        },
      );
    }
  }
}
