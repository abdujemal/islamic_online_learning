import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/notifications/service/notification_service.dart';
import 'package:islamic_online_learning/features/notifications/view/controller/notification_state.dart';

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationService service;
  final Ref ref;
  NotificationNotifier(
    this.service,
    this.ref,
  ) : super(NotificationState());

  Future<void> getNotifications(BuildContext context,
      {bool loadMore = false}) async {
    if (state.isLoadingMore) return;
    if (loadMore) {
      if (state.hasNoMore) return;
      state = state.copyWith(page: state.page + 1);
    } else {
      state = state.copyWith(page: 1, hasNoMore: false);
    }
    try {
      if (!loadMore) {
        state = state.copyWith(isLoading: true);
      } else {
        state = state.copyWith(isLoadingMore: true);
      }
      final chats = await service.getNotifications(page: state.page);
      // print(confusions);
      if (!loadMore) {
        state = state.copyWith(
          isLoading: false,
          notifications: chats,
        );
      } else {
        state = state.copyWith(
          isLoadingMore: false,
          hasNoMore: chats.isEmpty,
          notifications: [
            ...state.notifications,
            ...chats,
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
        "Error happended!",
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

  Future<void> setUnreadNotifications(int val, {read = false}) async {
    if (read) {
      await service.readNotifications();
    }
    state = state.copyWith(
      unreadNotifications: val,
    );
  }
}
