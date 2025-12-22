import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/groupChat/model/chat.dart';
import 'package:islamic_online_learning/features/groupChat/service/group_chat_service.dart';
import 'package:islamic_online_learning/features/groupChat/view/controller/group_chat_state.dart';

class GroupChatNotifier extends StateNotifier<GroupChatState> {
  final GroupChatService service;
  final Ref ref;
  GroupChatNotifier(
    this.service,
    this.ref,
  ) : super(GroupChatState());

  Future<void> getGroupChat(BuildContext context,
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
      final chats = await service.getGroupChat(page: state.page);
      // print(confusions);
      if (!loadMore) {
        state = state.copyWith(
          isLoading: false,
          groupChats: chats,
        );
      } else {
        state = state.copyWith(
          isLoadingMore: false,
          hasNoMore: chats.isEmpty,
          groupChats: [
            ...state.groupChats,
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

  Future<bool> sendGroupChat(
    String message,
    String? replyId,
    BuildContext context,
    void Function(Chat chat) launchSocket,
  ) async {
    try {
      state = state.copyWith(chatAdding: true);
      final chat = await service.sendGroupChat(message, replyId);
      launchSocket(chat);
      state = state.copyWith(
        chatAdding: false,
        // groupChats: [
        //   chat,
        //   ...state.groupChats,
        // ],
      );
      return true;
    } on ConnectivityException catch (err) {
      state = state.copyWith(chatAdding: false);

      toast(err.message, ToastType.error, context);
      return false;
    } catch (e) {
      state = state.copyWith(chatAdding: false);

      final errorMsg = getErrorMsg(
        e.toString(),
        "Error happended!",
      );
      handleError(
        e.toString(),
        context,
        ref,
        () async {
          toast(errorMsg, ToastType.error, context);
        },
      );
      return false;
    }
  }

  Future<bool> editGroupChat(
    String message,
    String chatId,
    BuildContext context,
    void Function(Chat chat) launchSocket,
  ) async {
    try {
      state = state.copyWith(chatAdding: true);
      final chat = await service.editGroupChat(message, chatId);
      launchSocket(chat);
      state = state.copyWith(
        chatAdding: false,
        // groupChats:
        //     state.groupChats.map((e) => e.id == chat.id ? chat : e).toList(),
      );
      return true;
    } on ConnectivityException catch (err) {
      state = state.copyWith(chatAdding: false);

      toast(err.message, ToastType.error, context);
      return false;
    } catch (e) {
      state = state.copyWith(chatAdding: false);

      final errorMsg = getErrorMsg(
        e.toString(),
        "Error happended!",
      );
      handleError(
        e.toString(),
        context,
        ref,
        () async {
          toast(errorMsg, ToastType.error, context);
        },
      );
      return false;
    }
  }

  Future<bool> deleteGroupChat(
    String chatId,
    BuildContext context,
    void Function(Chat chat) launchSocket,
  ) async {
    try {
      // state = state.copyWith(chatAdding: true);
      toast("Deleting...", ToastType.normal, context);
      final chat = await service.deleteGroupChat(chatId);
      launchSocket(chat);
      // state = state.copyWith(
      //   chatAdding: false,
      //   // groupChats:
      //   //     state.groupChats.map((e) => e.id == chat.id ? chat : e).toList(),
      // );
      return true;
    } on ConnectivityException catch (err) {
      // state = state.copyWith(chatAdding: false);

      toast(err.message, ToastType.error, context);
      return false;
    } catch (e) {
      // state = state.copyWith(chatAdding: false);

      final errorMsg = getErrorMsg(
        e.toString(),
        "Error happended!",
      );
      handleError(
        e.toString(),
        context,
        ref,
        () async {
          toast(errorMsg, ToastType.error, context);
        },
      );
      return false;
    }
  }

  void addNewChatToTheList(Chat chat) {
    state = state.copyWith(
      groupChats: [
        chat,
        ...state.groupChats,
      ],
    );
  }

  void editChatFromTheList(Chat chat) {
    state = state.copyWith(
      groupChats: state.groupChats
          .map(
            (e) => e.id == chat.id ? chat : e,
          )
          .toList(),
    );
  }

  void editChatViewFromTheList(String groupId, String userId, String chatId) {
    state = state.copyWith(
      groupChats: state.groupChats
          .map(
            (e) => e.id == chatId
                ? e.copyWith(
                    viewedBy: [
                      ...e.viewedBy,
                      if (!e.viewedBy.contains(userId)) ...[
                        userId,
                      ]
                    ],
                  )
                : e,
          )
          .toList(),
    );
  }

  void deleteChatFromTheList(Chat chat) {
    state = state.copyWith(
      groupChats: state.groupChats.where((e) => e.id != chat.id).toList(),
    );
  }
}
