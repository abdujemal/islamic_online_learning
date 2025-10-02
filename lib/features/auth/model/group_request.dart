// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GroupRequest {
  final String id;
  final String message;
  final String userId;
  final String data;
  final DateTime date;
  final String groupId;
  GroupRequest({
    required this.id,
    required this.message,
    required this.userId,
    required this.data,
    required this.date,
    required this.groupId,
  });

  GroupRequest copyWith({
    String? id,
    String? message,
    String? userId,
    String? data,
    DateTime? date,
    String? groupId,
  }) {
    return GroupRequest(
      id: id ?? this.id,
      message: message ?? this.message,
      userId: userId ?? this.userId,
      data: data ?? this.data,
      date: date ?? this.date,
      groupId: groupId ?? this.groupId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'userId': userId,
      'data': data,
      'date': date.millisecondsSinceEpoch,
      'groupId': groupId,
    };
  }

  factory GroupRequest.fromMap(Map<String, dynamic> map) {
    return GroupRequest(
      id: map['id'] as String,
      message: map['message'] as String,
      userId: map['userId'] as String,
      data: map['data'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      groupId: map['groupId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupRequest.fromJson(String source) => GroupRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupRequest(id: $id, message: $message, userId: $userId, data: $data, date: $date, groupId: $groupId)';
  }

  @override
  bool operator ==(covariant GroupRequest other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.message == message &&
      other.userId == userId &&
      other.data == data &&
      other.date == date &&
      other.groupId == groupId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      message.hashCode ^
      userId.hashCode ^
      data.hashCode ^
      date.hashCode ^
      groupId.hashCode;
  }
}
