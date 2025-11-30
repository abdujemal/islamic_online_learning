// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Confusion {
  final String id;
  final String userId;
  final String audioUrl;
  final String? response;
  final String? rejectedBecause;
  final DateTime createdAt;
  final int onLesson;
  Confusion({
    required this.id,
    required this.userId,
    required this.audioUrl,
    this.response,
    this.rejectedBecause,
    required this.createdAt,
    required this.onLesson,
  });

  Confusion copyWith({
    String? id,
    String? userId,
    String? audioUrl,
    String? response,
    String? rejectedBecause,
    DateTime? createdAt,
    int? onLesson,
  }) {
    return Confusion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      audioUrl: audioUrl ?? this.audioUrl,
      response: response ?? this.response,
      rejectedBecause: rejectedBecause ?? this.rejectedBecause,
      createdAt: createdAt ?? this.createdAt,
      onLesson: onLesson ?? this.onLesson,
    );
  }

  static List<Confusion> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Confusion.fromMap(json)).toList();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'audioUrl': audioUrl,
      'response': response,
      'rejectedBecause': rejectedBecause,
      'createdAt': createdAt.toString(),
      'onLesson': onLesson,
    };
  }

  factory Confusion.fromMap(Map<String, dynamic> map) {
    return Confusion(
      id: map['id'] as String,
      userId: map['userId'] as String,
      audioUrl: map['audioUrl'] as String,
      response: map['response'] != null ? map['response'] as String : null,
      rejectedBecause: map['rejectedBecause'] != null
          ? map['rejectedBecause'] as String
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      onLesson: map['onLesson'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Confusion.fromJson(String source) =>
      Confusion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Confusion(id: $id, userId: $userId, audioUrl: $audioUrl, response: $response, rejectedBecause: $rejectedBecause, createdAt: $createdAt, onLesson: $onLesson)';
  }

  @override
  bool operator ==(covariant Confusion other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.audioUrl == audioUrl &&
        other.response == response &&
        other.rejectedBecause == rejectedBecause &&
        other.createdAt == createdAt &&
        other.onLesson == onLesson;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        audioUrl.hashCode ^
        response.hashCode ^
        rejectedBecause.hashCode ^
        createdAt.hashCode ^
        onLesson.hashCode;
  }
}
