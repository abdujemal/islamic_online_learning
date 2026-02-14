import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/notifications/service/notification_service.dart';
import 'package:islamic_online_learning/features/notifications/view/controller/notification_notifier.dart';
import 'package:islamic_online_learning/features/notifications/view/controller/notification_state.dart';

final notificationProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref.read(notificationProvider), ref);
});
