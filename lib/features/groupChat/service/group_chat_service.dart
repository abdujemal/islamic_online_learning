import 'dart:convert';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/groupChat/model/chat.dart';

class GroupChatService {
  Future<List<Chat>> getGroupChat({int page = 1}) async {
    final response = await customGetRequest(
      "$chatsApi?page=$page",
      authorized: true,
    );
    if (response.statusCode == 200) {
      return Chat.listFromJsonGC(response.body);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load chats: ${response.body}');
    }
  }

  Future<Chat> sendGroupChat(String message, String? replyId) async {
    final response = await customPostRequest(
      chatsApi,
      {
        "chatWithAdmin": false,
        "message": message,
        if(replyId != null)...{
        "replyToId": replyId,
        }
      },
      authorized: true,
    );
    if (response.statusCode == 200) {
      return Chat.fromMap(jsonDecode(response.body)["chat"]);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to add chat: ${response.body}');
    }
  }
}
