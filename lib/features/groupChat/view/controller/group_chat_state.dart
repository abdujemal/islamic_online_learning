import 'package:flutter/material.dart';
import 'package:islamic_online_learning/features/groupChat/model/chat.dart';

class GroupChatState {
  final bool isLoading, isLoadingMore, hasNoMore, initial, chatAdding;
  final int page;
  final List<Chat> groupChats;
  final String? error;

  GroupChatState({
    this.initial = true,
    this.page = 1,
    this.isLoading = false,
    this.hasNoMore = false,
    this.chatAdding = false,
    this.isLoadingMore = false,
    this.groupChats = const [],
    this.error,
  });

  Widget map({
    required Widget Function(GroupChatState _) loading,
    required Widget Function(GroupChatState _) loaded,
    required Widget Function(GroupChatState _) empty,
    required Widget Function(GroupChatState _) error,
  }) {
    if (initial) {
      return SizedBox();
    } else if (isLoading) {
      return loading(this);
    } else if (!isLoading && this.error != null) {
      return error(this);
    } else if (!isLoading && groupChats.isNotEmpty) {
      return loaded(this);
    } else if (!isLoading && groupChats.isEmpty) {
      return empty(this);
    } else {
      return SizedBox();
    }
  }

  GroupChatState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasNoMore,
    bool? chatAdding,
    int? page,
    List<Chat>? groupChats,
    String? error,
  }) {
    return GroupChatState(
      initial: false,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNoMore: hasNoMore ?? this.hasNoMore,
      isLoading: isLoading ?? this.isLoading,
      groupChats: groupChats ?? this.groupChats,
      page: page ?? this.page,
      chatAdding: chatAdding ?? this.chatAdding,
      error: error,
    );
  }
}
