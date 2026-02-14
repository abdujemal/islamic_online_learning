// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Chat {
  final String id;
  final String message;
  final String chatType;
  final String chatSenderType;
  final DateTime createdAt;
  final String? senderId;
  final String? replyToId;
  final bool chatWithAdmin;
  final String? groupId;
  final List<String> viewedBy;
  final Chat? replyTo;

  Chat({
    required this.id,
    required this.message,
    required this.chatType,
    required this.chatSenderType,
    required this.createdAt,
    this.senderId,
    this.replyToId,
    this.replyTo,
    required this.chatWithAdmin,
    this.groupId,
    required this.viewedBy,
  });

  Chat copyWith({
    String? id,
    String? message,
    String? chatType,
    String? chatSenderType,
    DateTime? createdAt,
    String? senderId,
    String? replyToId,
    bool? chatWithAdmin,
    String? groupId,
    List<String>? viewedBy,
    Chat? replyTo,
  }) {
    return Chat(
      id: id ?? this.id,
      message: message ?? this.message,
      chatType: chatType ?? this.chatType,
      chatSenderType: chatSenderType ?? this.chatSenderType,
      createdAt: createdAt ?? this.createdAt,
      senderId: senderId ?? this.senderId,
      replyToId: replyToId ?? this.replyToId,
      chatWithAdmin: chatWithAdmin ?? this.chatWithAdmin,
      groupId: groupId ?? this.groupId,
      viewedBy: viewedBy ?? this.viewedBy,
      replyTo: replyTo ?? this.replyTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'chatType': chatType,
      'chatSenderType': chatSenderType,
      'createdAt': createdAt.toString(),
      'senderId': senderId,
      'replyToId': replyToId,
      'chatWithAdmin': chatWithAdmin,
      'groupId': groupId,
      'viewedBy': viewedBy,
      'replyTo': replyTo
    };
  }

  static List<Chat> listFromJsonGC(String responseBody) {
    final parsed =
        jsonDecode(responseBody)["chat"]["group"]["chats"] as List<dynamic>;
    return parsed.map((json) => Chat.fromMap(json)).toList();
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
        id: map['id'] as String,
        message: map['message'] as String,
        chatType: map['chatType'] as String,
        chatSenderType: map['chatSenderType'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String).toLocal(),
        senderId: map['senderId'] != null ? map['senderId'] as String : null,
        replyToId: map['replyToId'] != null ? map['replyToId'] as String : null,
        chatWithAdmin: map['chatWithAdmin'] as bool,
        groupId: map['groupId'] != null ? map['groupId'] as String : null,
        viewedBy: List<String>.from((map['viewedBy'] as List<dynamic>)),
        replyTo: map['replyTo'] != null
            ? Chat.fromMap(map['replyTo'] as Map<String, dynamic>)
            : null);
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(id: $id, message: $message, chatType: $chatType, chatSenderType: $chatSenderType, createdAt: $createdAt, senderId: $senderId, replyToId: $replyToId, chatWithAdmin: $chatWithAdmin, groupId: $groupId, viewedBy: $viewedBy, replyTo: $replyTo)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.message == message &&
        other.chatType == chatType &&
        other.chatSenderType == chatSenderType &&
        other.createdAt == createdAt &&
        other.senderId == senderId &&
        other.replyToId == replyToId &&
        other.chatWithAdmin == chatWithAdmin &&
        other.groupId == groupId &&
        other.replyTo == replyTo &&
        listEquals(other.viewedBy, viewedBy);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        message.hashCode ^
        chatType.hashCode ^
        chatSenderType.hashCode ^
        createdAt.hashCode ^
        senderId.hashCode ^
        replyToId.hashCode ^
        chatWithAdmin.hashCode ^
        replyTo.hashCode ^
        groupId.hashCode ^
        viewedBy.hashCode;
  }
}
