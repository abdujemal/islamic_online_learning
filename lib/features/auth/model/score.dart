// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Score {
  final String type;
  final int totalScore;
  final List<ScoreSegment> scoreSegments;
  Score({
    required this.type,
    required this.totalScore,
    required this.scoreSegments,
  });

  Score copyWith({
    String? type,
    int? totalScore,
    List<ScoreSegment>? scoreSegments,
  }) {
    return Score(
      type: type ?? this.type,
      totalScore: totalScore ?? this.totalScore,
      scoreSegments: scoreSegments ?? this.scoreSegments,
    );
  }

  static Score? get(String title, WidgetRef ref, List<Score> scores) {
    if (scores.isEmpty) {
      return null;
    }
    return scores.firstWhere((e) => e.type == title);
  }

  static List<Score> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Score.fromMap(json)).toList();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'totalScore': totalScore,
      'scoreSegments': scoreSegments.map((x) => x.toMap()).toList(),
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      type: map['type'] as String,
      totalScore: map['totalScore'] as int,
      scoreSegments: List<ScoreSegment>.from(
        (map['scoreSegments'] as List<dynamic>).map<ScoreSegment>(
          (x) => ScoreSegment.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Score.fromJson(String source) =>
      Score.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Score(type: $type, totalScore: $totalScore, scoreSegments: $scoreSegments)';

  @override
  bool operator ==(covariant Score other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.totalScore == totalScore &&
        listEquals(other.scoreSegments, scoreSegments);
  }

  @override
  int get hashCode =>
      type.hashCode ^ totalScore.hashCode ^ scoreSegments.hashCode;
}

class ScoreSegment {
  final String name;
  final int score;
  ScoreSegment({
    required this.name,
    required this.score,
  });

  ScoreSegment copyWith({
    String? name,
    int? score,
  }) {
    return ScoreSegment(
      name: name ?? this.name,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'score': score,
    };
  }

  factory ScoreSegment.fromMap(Map<String, dynamic> map) {
    return ScoreSegment(
      name: map['name'] as String,
      score: map['score'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScoreSegment.fromJson(String source) =>
      ScoreSegment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ScoreSegment(name: $name, score: $score)';

  @override
  bool operator ==(covariant ScoreSegment other) {
    if (identical(this, other)) return true;

    return other.name == name && other.score == score;
  }

  @override
  int get hashCode => name.hashCode ^ score.hashCode;
}
