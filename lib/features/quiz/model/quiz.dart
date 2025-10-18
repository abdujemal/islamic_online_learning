// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Quiz {
  final String id;
  final String question;
  final List<String> options;
  final String? hint;
  final String lessonId;
  final String assignedCourseId;
  final String curriculumId;
  final int answer;
  Quiz({
    required this.id,
    required this.question,
    required this.options,
    this.hint,
    required this.lessonId,
    required this.assignedCourseId,
    required this.curriculumId,
    required this.answer,
  });

  Quiz copyWith({
    String? id,
    String? question,
    List<String>? options,
    String? hint,
    String? lessonId,
    String? assignedCourseId,
    String? curriculumId,
    int? answer,
  }) {
    return Quiz(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      hint: hint ?? this.hint,
      lessonId: lessonId ?? this.lessonId,
      assignedCourseId: assignedCourseId ?? this.assignedCourseId,
      curriculumId: curriculumId ?? this.curriculumId,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'options': options,
      'hint': hint,
      'lessonId': lessonId,
      'assignedCourseId': assignedCourseId,
      'curriculumId': curriculumId,
      'answer': answer,
    };
  }

  static List<Quiz> listFromJson(String responseBody, {bool fromDb = false}) {
    final parsed = jsonDecode(responseBody)["currentCurriculum"]["quizzes"]
        as List<dynamic>;
    return parsed.map((json) => Quiz.fromMap(json)).toList();
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      id: map['id'] as String,
      question: map['question'] as String,
      options: List<String>.from((map['options'] as List<dynamic>)),
      hint: map['hint'] != null ? map['hint'] as String : null,
      lessonId: map['lessonId'] as String,
      assignedCourseId: map['assignedCourseId'] as String,
      curriculumId: map['curriculumId'] as String,
      answer: map['answer'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Quiz.fromJson(String source) =>
      Quiz.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Quiz(id: $id, question: $question, options: $options, hint: $hint, lessonId: $lessonId, assignedCourseId: $assignedCourseId, curriculumId: $curriculumId, answer: $answer)';
  }

  @override
  bool operator ==(covariant Quiz other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.question == question &&
        listEquals(other.options, options) &&
        other.hint == hint &&
        other.lessonId == lessonId &&
        other.assignedCourseId == assignedCourseId &&
        other.curriculumId == curriculumId &&
        other.answer == answer;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        options.hashCode ^
        hint.hashCode ^
        lessonId.hashCode ^
        assignedCourseId.hashCode ^
        curriculumId.hashCode ^
        answer.hashCode;
  }
}
