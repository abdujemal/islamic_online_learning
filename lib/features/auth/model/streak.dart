// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:islamic_online_learning/features/auth/model/score.dart';

class Streak {
  final String id;
  final String streakType;
  final List<Score> scores;
  final String userId;
  final DateTime date;
  Streak({
    required this.id,
    required this.streakType,
    required this.scores,
    required this.userId,
    required this.date,
  });

  Streak copyWith({
    String? id,
    String? streakType,
    List<Score>? scores,
    String? userId,
    DateTime? date,
  }) {
    return Streak(
      id: id ?? this.id,
      streakType: streakType ?? this.streakType,
      scores: scores ?? this.scores,
      userId: userId ?? this.userId,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'streakType': streakType,
      'scores': scores.map((x) => x.toMap()).toList(),
      'userId': userId,
      'date': date.toString(),
    };
  }

  factory Streak.fromMap(Map<String, dynamic> map) {
    return Streak(
      id: map['id'] as String,
      streakType: map['streakType'] as String,
      scores: List<Score>.from(
        (map['scores'] as List<dynamic>).map<Score>(
          (x) => Score.fromMap(x as Map<String, dynamic>),
        ),
      ),
      userId: map['userId'] as String,
      date: DateTime.parse(map['date'] as String).toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Streak.fromJson(String source) =>
      Streak.fromMap(json.decode(source)["streak"] as Map<String, dynamic>);

  @override
  String toString() {
    return 'Streak(id: $id, streakType: $streakType, scores: $scores, userId: $userId, date: $date)';
  }

  @override
  bool operator ==(covariant Streak other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.streakType == streakType &&
        listEquals(other.scores, scores) &&
        other.userId == userId &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        streakType.hashCode ^
        scores.hashCode ^
        userId.hashCode ^
        date.hashCode;
  }
}

class StreakWNo {
  final Streak streak;
  final int streakNo;
  StreakWNo({
    required this.streak,
    required this.streakNo,
  });
  

  StreakWNo copyWith({
    Streak? streak,
    int? streakNo,
  }) {
    return StreakWNo(
      streak: streak ?? this.streak,
      streakNo: streakNo ?? this.streakNo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'streak': streak.toMap(),
      'streakNo': streakNo,
    };
  }

  factory StreakWNo.fromMap(Map<String, dynamic> map) {
    return StreakWNo(
      streak: Streak.fromMap(map['streak'] as Map<String,dynamic>),
      streakNo: map['streakNo'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StreakWNo.fromJson(String source) => StreakWNo.fromMap(json.decode(source)["streakInfo"] as Map<String, dynamic>);

  @override
  String toString() => 'StreakWNo(streak: $streak, streakNo: $streakNo)';

  @override
  bool operator ==(covariant StreakWNo other) {
    if (identical(this, other)) return true;
  
    return 
      other.streak == streak &&
      other.streakNo == streakNo;
  }

  @override
  int get hashCode => streak.hashCode ^ streakNo.hashCode;
}
