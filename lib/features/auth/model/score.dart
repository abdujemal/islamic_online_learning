// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class Score {
  final String id;
  final String targetType;
  final String targetId;
  final int score;
  final int outOf;
  final int afterLesson;
  final bool gradeWaiting;
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
    required this.afterLesson,
  });

  Score copyWith(
      {String? id,
      String? targetType,
      String? targetId,
      int? score,
      bool? gradeWaiting,
      int? outOf,
      String? userId,
      DateTime? date,
      int? afterLesson}) {
    return Score(
      id: id ?? this.id,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      score: score ?? this.score,
      gradeWaiting: gradeWaiting ?? this.gradeWaiting,
      outOf: outOf ?? this.outOf,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      afterLesson: afterLesson ?? this.afterLesson,
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
      'afterLesson': afterLesson,
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
      afterLesson: map["afterLesson"] as int,
      date: DateTime.parse(map['date'] as String).toLocal(),
    );
  }

  //from archive url to dart model class
  static Future<List<Score>> fetchArchivedScores(String url) async {
    final httpClient = HttpClient();

    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode != 200) {
      throw Exception('Failed to download archive');
    }

    // 1. Read compressed bytes
    final compressedBytes = await consolidateHttpClientResponseBytes(response);

    // 2. Decompress gzip
    final decompressedBytes = gzip.decode(compressedBytes);

    // 3. Convert bytes → String
    final jsonString = utf8.decode(decompressedBytes);

    // 4. Decode JSON → Map
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    final List<dynamic> scoresJson = jsonMap['scores'];
    final List<dynamic> streaksJson = jsonMap['streaks'];

    // 5. Map → Dart model
    final List<Score> scores = scoresJson
        .map((e) => Score.fromMap(e as Map<String, dynamic>))
        .toList();

    for (final data in streaksJson) {
      for (final scoreData in data["scores"]) {
        scores.add(Score.fromMap(scoreData));
      }
    }

    return scores;
  }

  static Future<List<Score>> fetchArchivedScoresMultiple(List<String> urls){
    return Future.wait(urls.map((url) => fetchArchivedScores(url)))
        .then((lists) => lists.expand((i) => i).toList());
  }

  String toJson() => json.encode(toMap());

  factory Score.fromJson(String source) =>
      Score.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Score(id: $id, targetType: $targetType, afterLesson: $afterLesson, targetId: $targetId, score: $score, gradeWaiting: $gradeWaiting, outOf: $outOf, userId: $userId, date: $date)';
  }

  @override
  bool operator ==(covariant Score other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.targetType == targetType &&
        other.targetId == targetId &&
        other.score == score &&
        other.gradeWaiting == gradeWaiting &&
        other.outOf == outOf &&
        other.afterLesson == afterLesson &&
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
        afterLesson.hashCode ^
        date.hashCode;
  }
}
