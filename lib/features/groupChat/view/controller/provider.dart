import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/groupChat/service/group_chat_service.dart';
import 'package:islamic_online_learning/features/groupChat/view/controller/group_chat_notifier.dart';
import 'package:islamic_online_learning/features/groupChat/view/controller/group_chat_state.dart';

final groupChatServiceProvider = Provider<GroupChatService>((ref) {
  return GroupChatService();
});

final groupChatNotifierProvider =
    StateNotifierProvider<GroupChatNotifier, GroupChatState>(
  (ref) {
    return GroupChatNotifier(
      ref.read(groupChatServiceProvider),
      ref,
    );
  },
);
