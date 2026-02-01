// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CurriculumScore {
  final String id;
  final String userId;
  final String curriculumId;
  final String curriculumTitle;
  final String? certificateUrl;
  final int score;
  final int outOf;
  final DateTime startDate;
  final DateTime endDate;
  CurriculumScore({
    required this.id,
    required this.userId,
    required this.curriculumId,
    required this.curriculumTitle,
    this.certificateUrl,
    required this.score,
    required this.outOf,
    required this.startDate,
    required this.endDate,
  });

  CurriculumScore copyWith({
    String? id,
    String? userId,
    String? curriculumId,
    String? curriculumTitle,
    String? certificateUrl,
    int? score,
    int? outOf,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return CurriculumScore(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      curriculumId: curriculumId ?? this.curriculumId,
      curriculumTitle: curriculumTitle ?? this.curriculumTitle,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      score: score ?? this.score,
      outOf: outOf ?? this.outOf,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  static List<CurriculumScore> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => CurriculumScore.fromMap(json)).toList();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'curriculumId': curriculumId,
      "curriculumTitle": curriculumTitle,
      'certificateUrl': certificateUrl,
      'score': score,
      'outOf': outOf,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
    };
  }

  factory CurriculumScore.fromMap(Map<String, dynamic> map) {
    print("CurriculumScore.fromMap");
    return CurriculumScore(
      id: map['id'] as String,
      userId: map['userId'] as String,
      curriculumId: map['curriculumId'] as String,
      curriculumTitle: map['curriculumTitle'] as String,
      certificateUrl: map['certificateUrl'] != null
          ? map['certificateUrl'] as String
          : null,
      score: map['score'] as int,
      outOf: map['outOf'] as int,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory CurriculumScore.fromJson(String source) =>
      CurriculumScore.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CurriculumScore(id: $id, userId: $userId, curriculumId: $curriculumId, curriculumTitle: $curriculumTitle, certificateUrl: $certificateUrl, score: $score, outOf: $outOf, startDate: $startDate, endDate: $endDate)';
  }

  @override
  bool operator ==(covariant CurriculumScore other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        other.curriculumId == curriculumId &&
        other.curriculumTitle == curriculumTitle &&
        other.certificateUrl == certificateUrl &&
        other.score == score &&
        other.outOf == outOf &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        curriculumId.hashCode ^
        curriculumTitle.hashCode ^
        certificateUrl.hashCode ^
        score.hashCode ^
        outOf.hashCode ^
        startDate.hashCode ^
        endDate.hashCode;
  }
}
