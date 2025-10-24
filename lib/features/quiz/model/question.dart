// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Question {
  final String id;
  final String question;
  final String hint;
  final String lessonId;
  Question({
    required this.id,
    required this.question,
    required this.hint,
    required this.lessonId,
  });

  Question copyWith({
    String? id,
    String? question,
    String? hint,
    String? lessonId,
  }) {
    return Question(
      id: id ?? this.id,
      question: question ?? this.question,
      hint: hint ?? this.hint,
      lessonId: lessonId ?? this.lessonId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'hint': hint,
      'lessonId': lessonId,
    };
  }

  static List<Question> listFromJson(String responseBody, {bool fromDb = false}) {
    final parsed = jsonDecode(responseBody)
        as List<dynamic>;
    return parsed.map((json) => Question.fromMap(json)).toList();
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as String,
      question: map['question'] as String,
      hint: map['hint'] as String,
      lessonId: map['lessonId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) => Question.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Question(id: $id, question: $question, hint: $hint, lessonId: $lessonId)';
  }

  @override
  bool operator ==(covariant Question other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.question == question &&
      other.hint == hint &&
      other.lessonId == lessonId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      question.hashCode ^
      hint.hashCode ^
      lessonId.hashCode;
  }
}
