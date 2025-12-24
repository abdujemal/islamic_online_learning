import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/notifications/model/notification.dart';

class NotificationState {
  final bool isLoading, isLoadingMore, hasNoMore, initial;
  final int page;
  final int unreadNotifications;
  final List<NotificationModel> notifications;
  final String? error;

  NotificationState({
    this.initial = true,
    this.page = 1,
    this.unreadNotifications = 0,
    this.isLoading = false,
    this.hasNoMore = false,
    this.isLoadingMore = false,
    this.notifications = const [],
    this.error,
  });

  Widget map({
    required Widget Function(NotificationState _) loading,
    required Widget Function(NotificationState _) loaded,
    required Widget Function(NotificationState _) empty,
    required Widget Function(NotificationState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && notifications.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && notifications.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  NotificationState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNoMore,
    int? page,
    int? unreadNotifications,
    List<NotificationModel>? notifications,
    String? error,
  }) {
    return NotificationState(
      initial: false,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNoMore: hasNoMore ?? this.hasNoMore,
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      page: page ?? this.page,
      error: error,
    );
  }
}
