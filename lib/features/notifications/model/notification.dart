// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String category;
  final DateTime sentAt;
  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.sentAt,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? category,
    DateTime? sentAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      category: category ?? this.category,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'message': message,
      'category': category,
      'sentAt': sentAt.toString(),
    };
  }

  static List<NotificationModel> listFromJson(String responseBody) {
    final parsed =
        jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => NotificationModel.fromMap(json)).toList();
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      message: map['message'] as String,
      category: map['category'] as String,
      sentAt: DateTime.parse(map['sentAt'] as String).toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) => NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, message: $message, category: $category, sentAt: $sentAt)';
  }

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.message == message &&
      other.category == category &&
      other.sentAt == sentAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      message.hashCode ^
      category.hashCode ^
      sentAt.hashCode;
  }
}
