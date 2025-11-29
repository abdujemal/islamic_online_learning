// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:islamic_online_learning/features/auth/model/score.dart';

class Streak {
  final String id;
  final String streakType;
  final String scoreId;
  final Score? score;
  final String userId;
  final DateTime date;
  Streak({
    required this.id,
    required this.streakType,
    required this.scoreId,
    this.score,
    required this.userId,
    required this.date,
  });

  Streak copyWith({
    String? id,
    String? streakType,
    String? scoreId,
    Score? score,
    String? userId,
    DateTime? date,
  }) {
    return Streak(
      id: id ?? this.id,
      streakType: streakType ?? this.streakType,
      scoreId: scoreId ?? this.scoreId,
      score: score ?? this.score,
      userId: userId ?? this.userId,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'streakType': streakType,
      'scoreId': scoreId,
      'score': score?.toMap(),
      'userId': userId,
      'date': date.toString(),
    };
  }

  factory Streak.fromMap(Map<String, dynamic> map) {
    print("map: $map");
    return Streak(
      id: map['id'] as String,
      streakType: map['streakType'] as String,
      scoreId: map['scoreId'] as String,
      score: map['score'] != null
          ? Score.fromMap(map['score'] as Map<String, dynamic>)
          : null,
      userId: map['userId'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  static List<Streak> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Streak.fromMap(json)).toList();
  }

  String toJson() => json.encode(toMap());

  factory Streak.fromJson(String source) =>
      Streak.fromMap(json.decode(source)["streak"] as Map<String, dynamic>);

  @override
  String toString() {
    return 'Streak(id: $id, streakType: $streakType, scoreId: $scoreId, score: $score, userId: $userId, date: $date)';
  }

  @override
  bool operator ==(covariant Streak other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.streakType == streakType &&
        other.scoreId == scoreId &&
        other.score == score &&
        other.userId == userId &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        streakType.hashCode ^
        scoreId.hashCode ^
        score.hashCode ^
        userId.hashCode ^
        date.hashCode;
  }
}
