// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class TestAttempt {
  final String id;
  final int afterLessonNum;
  final bool checked;
  final DateTime startTime;
  final DateTime endTime;
  final int courseNum;
  final String curriculumId;
  final String userId;
  final List<QuestionAttempt> questionAttempts;
  TestAttempt({
    required this.id,
    required this.afterLessonNum,
    required this.checked,
    required this.startTime,
    required this.endTime,
    required this.courseNum,
    required this.curriculumId,
    required this.userId,
    required this.questionAttempts,
  });

  TestAttempt copyWith({
    String? id,
    int? afterLessonNum,
    bool? checked,
    DateTime? startTime,
    DateTime? endTime,
    int? courseNum,
    String? curriculumId,
    String? userId,
    List<QuestionAttempt>? questionAttempts,
  }) {
    return TestAttempt(
      id: id ?? this.id,
      afterLessonNum: afterLessonNum ?? this.afterLessonNum,
      checked: checked ?? this.checked,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      courseNum: courseNum ?? this.courseNum,
      curriculumId: curriculumId ?? this.curriculumId,
      userId: userId ?? this.userId,
      questionAttempts: questionAttempts ?? this.questionAttempts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'afterLessonNum': afterLessonNum,
      'checked': checked,
      'startTime': startTime.toString(),
      'endTime': endTime.toString(),
      'courseNum': courseNum,
      'curriculumId': curriculumId,
      'userId': userId,
      'questionAttempts': questionAttempts.map((x) => x.toMap()).toList(),
    };
  }

  factory TestAttempt.fromMap(Map<String, dynamic> map) {
    // print("location: TestAttempt");
    print("TestAttempt.fromMap");
    return TestAttempt(
      id: map['id'] as String,
      afterLessonNum: map['afterLessonNum'] as int,
      checked: map['checked'] as bool,
      startTime: DateTime.parse(map['startTime'] as String).toLocal(),
      endTime: DateTime.parse(map['endTime'] as String).toLocal(),
      courseNum: map['courseNum'] as int,
      curriculumId: map['curriculumId'] as String,
      userId: map['userId'] as String,
      questionAttempts: map['questionAttempts'] == null
          ? []
          : List<QuestionAttempt>.from(
              (map['questionAttempts'] as List<dynamic>).map<QuestionAttempt>(
                (x) => QuestionAttempt.fromMap(x),
              ),
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TestAttempt.fromJson(String source) =>
      TestAttempt.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TestAttempt(id: $id, afterLessonNum: $afterLessonNum, checked: $checked, startTime: $startTime, endTime: $endTime, courseNum: $courseNum, curriculumId: $curriculumId, userId: $userId, questionAttempts: $questionAttempts)';
  }

  @override
  bool operator ==(covariant TestAttempt other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.afterLessonNum == afterLessonNum &&
        other.checked == checked &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.courseNum == courseNum &&
        other.curriculumId == curriculumId &&
        other.userId == userId &&
        listEquals(other.questionAttempts, questionAttempts);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        afterLessonNum.hashCode ^
        checked.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        courseNum.hashCode ^
        curriculumId.hashCode ^
        userId.hashCode ^
        questionAttempts.hashCode;
  }
}

class QuestionAttempt {
  final String questionId;
  final String answer;
  QuestionAttempt({
    required this.questionId,
    required this.answer,
  });

  QuestionAttempt copyWith({
    String? questionId,
    String? answer,
  }) {
    return QuestionAttempt(
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questionId': questionId,
      'answer': answer,
    };
  }

  factory QuestionAttempt.fromMap(Map<String, dynamic> map) {
    return QuestionAttempt(
      questionId: map['questionId'] as String,
      answer: map['answer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionAttempt.fromJson(String source) =>
      QuestionAttempt.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'QuestionAttempt(questionId: $questionId, answer: $answer)';

  @override
  bool operator ==(covariant QuestionAttempt other) {
    if (identical(this, other)) return true;

    return other.questionId == questionId && other.answer == answer;
  }

  @override
  int get hashCode => questionId.hashCode ^ answer.hashCode;
}
