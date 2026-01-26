import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CourseScore {
  final String id;
  final String courseId;
  final String curriculumId;
  final int score;
  final int outOf;
  final int noOfLessonPerDay;
  final DateTime startDate;
  final DateTime endDate;
  final String userId;
  CourseScore({
    required this.id,
    required this.courseId,
    required this.curriculumId,
    required this.score,
    required this.outOf,
    required this.noOfLessonPerDay,
    required this.startDate,
    required this.endDate,
    required this.userId,
  });

  CourseScore copyWith({
    String? id,
    String? courseId,
    String? curriculumId,
    int? score,
    int? outOf,
    int? noOfLessonPerDay,
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
  }) {
    return CourseScore(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      curriculumId: curriculumId ?? this.curriculumId,
      score: score ?? this.score,
      outOf: outOf ?? this.outOf,
      noOfLessonPerDay: noOfLessonPerDay ?? this.noOfLessonPerDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'curriculumId': curriculumId,
      'score': score,
      'outOf': outOf,
      'noOfLessonPerDay': noOfLessonPerDay,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'userId': userId,
    };
  }

  factory CourseScore.fromMap(Map<String, dynamic> map) {
    return CourseScore(
      id: map['id'] as String,
      courseId: map['courseId'] as String,
      curriculumId: map['curriculumId'] as String,
      score: map['score'] as int,
      outOf: map['outOf'] as int,
      noOfLessonPerDay: map['noOfLessonPerDay'] as int,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseScore.fromJson(String source) => CourseScore.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CourseScore(id: $id, courseId: $courseId, curriculumId: $curriculumId, score: $score, outOf: $outOf, noOfLessonPerDay: $noOfLessonPerDay, startDate: $startDate, endDate: $endDate, userId: $userId)';
  }

  @override
  bool operator ==(covariant CourseScore other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.courseId == courseId &&
      other.curriculumId == curriculumId &&
      other.score == score &&
      other.outOf == outOf &&
      other.noOfLessonPerDay == noOfLessonPerDay &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      courseId.hashCode ^
      curriculumId.hashCode ^
      score.hashCode ^
      outOf.hashCode ^
      noOfLessonPerDay.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      userId.hashCode;
  }
}
