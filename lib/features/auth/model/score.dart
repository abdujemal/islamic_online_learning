// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Score {
  final String id;
  final String targetType;
  final String targetId;
  final int score;
  final bool gradeWaiting;
  final int outOf;
  final String userId;
  final DateTime date;
  Score({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.score,
    required this.gradeWaiting,
    required this.outOf,
    required this.userId,
    required this.date,
  });

  Score copyWith({
    String? id,
    String? targetType,
    String? targetId,
    int? score,
    bool? gradeWaiting,
    int? outOf,
    String? userId,
    DateTime? date,
  }) {
    return Score(
      id: id ?? this.id,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      score: score ?? this.score,
      gradeWaiting: gradeWaiting ?? this.gradeWaiting,
      outOf: outOf ?? this.outOf,
      userId: userId ?? this.userId,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'targetType': targetType,
      'targetId': targetId,
      'score': score,
      'gradeWaiting': gradeWaiting,
      'outOf': outOf,
      'userId': userId,
      'date': date.toString(),
    };
  }

  factory Score.fromMap(Map<String, dynamic> map) {
    return Score(
      id: map['id'] as String,
      targetType: map['targetType'] as String,
      targetId: map['targetId'] as String,
      score: map['score'] as int,
      gradeWaiting: map['gradeWaiting'] as bool,
      outOf: map['outOf'] as int,
      userId: map['userId'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Score.fromJson(String source) => Score.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Score(id: $id, targetType: $targetType, targetId: $targetId, score: $score, gradeWaiting: $gradeWaiting, outOf: $outOf, userId: $userId, date: $date)';
  }

  @override
  bool operator ==(covariant Score other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.targetType == targetType &&
      other.targetId == targetId &&
      other.score == score &&
      other.gradeWaiting == gradeWaiting &&
      other.outOf == outOf &&
      other.userId == userId &&
      other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      targetType.hashCode ^
      targetId.hashCode ^
      score.hashCode ^
      gradeWaiting.hashCode ^
      outOf.hashCode ^
      userId.hashCode ^
      date.hashCode;
  }
}
