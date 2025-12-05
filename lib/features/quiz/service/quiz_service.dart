// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/model/streak.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/quiz/model/question.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';
import 'package:islamic_online_learning/features/quiz/model/test_attempt.dart';

class QuizService {
  Future<List<Quiz>> getQuizzes(String lessonId) async {
    final res = await customGetRequest(
      getQuizzesApi.replaceAll("{lessonId}", lessonId),
      authorized: true,
    );

    if (res.statusCode == 200) {
      final quizzes = Quiz.listFromJson(res.body);
      return quizzes;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception(res.body);
    }
  }

  Future<List<Question>> getTestQuestions() async {
    final res = await customGetRequest(
      getTestQuestionApi,
      authorized: true,
    );

    if (res.statusCode == 200) {
      final quizzes = Question.listFromJson(res.body);
      return quizzes;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception(res.body);
    }
  }

  Future<int> getGivenMinute() async {
    final res = await customGetRequest(
      getGivenTimeApi,
      authorized: true,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["monthly"] as int;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception(res.body);
    }
  }

  Future<bool> isThereUnfinishedTest() async {
    final res = await customPostRequest(
      getCheckTestApi,
      {},
      authorized: true,
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)["testStatus"] as bool;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception(res.body);
    }
  }

  Future<TestAttempt> addTestAttempt(String title) async {
    final res = await customPostRequest(
      addTestAttemptApi,
      {"title": "$title"},
      authorized: true,
    );

    if (res.statusCode == 200) {
      final testAttempt = TestAttempt.fromJson(res.body);
      return testAttempt;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception(res.body);
    }
  }

  Future<void> submitTest(String testId, List<QA> QAs) async {
    final res = await customPostRequest(
      submitTestApi,
      {
        "testId": testId,
        "questionAttempts": QAs.map(
          (e) => {
            "questionId": e.questionId,
            "answer": e.answer,
          },
        ).toList()
      },
      authorized: true,
    );

    if (res.statusCode == 200) {
      // final streak = Streak.fromJson(res.body);
      // return streak;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception(res.body);
    }
  }

  Future<Streak> submitQuizzes(Lesson lesson, List<String> answers) async {
    final res = await customPostRequest(
      submitQuizApi,
      {
        "answers": answers,
        "streakType": "Lesson",
        "streakPass": dotenv.get("STREAK_PASS"),
        "lessonId": lesson.id,
      },
      authorized: true,
    );

    if (res.statusCode == 200) {
      final streak = Streak.fromJson(res.body);
      return streak;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception("ጥያቄዎቹን ማረም አልተቻለም!: ${res.body}");
    }
  }

  Future<Streak> addLessonStreak(String lessonId) async {
    final res = await customPostRequest(
      addStreakApi,
      {
        "streakType": "Lesson",
        "streakPass": dotenv.get("STREAK_PASS"),
        "lessonId": lessonId,
      },
      authorized: true,
    );
    if (res.statusCode == 200) {
      final streak = Streak.fromJson(res.body);
      return streak;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception("ጥያቄዎቹን ማረም አልተቻለም!: ${res.body}");
    }
  }
}

class QA {
  final String questionId;
  final String answer;
  QA({
    required this.questionId,
    required this.answer,
  });

  QA copyWith({
    String? questionId,
    String? answer,
  }) {
    return QA(
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

  factory QA.fromMap(Map<String, dynamic> map) {
    return QA(
      questionId: map['questionId'] as String,
      answer: map['answer'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QA.fromJson(String source) =>
      QA.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'QA(questionId: $questionId, answer: $answer)';

  @override
  bool operator ==(covariant QA other) {
    if (identical(this, other)) return true;

    return other.questionId == questionId && other.answer == answer;
  }

  @override
  int get hashCode => questionId.hashCode ^ answer.hashCode;
}

class QuizAns {
  final String quizId;
  final int answer;
  QuizAns({
    required this.quizId,
    required this.answer,
  });

  QuizAns copyWith({
    String? quizId,
    int? answer,
  }) {
    return QuizAns(
      quizId: quizId ?? this.quizId,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quizId': quizId,
      'answer': answer,
    };
  }

  factory QuizAns.fromMap(Map<String, dynamic> map) {
    return QuizAns(
      quizId: map['quizId'] as String,
      answer: map['answer'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizAns.fromJson(String source) =>
      QuizAns.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'QuizAns(quizId: $quizId, answer: $answer)';

  @override
  bool operator ==(covariant QuizAns other) {
    if (identical(this, other)) return true;

    return other.quizId == quizId && other.answer == answer;
  }

  @override
  int get hashCode => quizId.hashCode ^ answer.hashCode;
}
