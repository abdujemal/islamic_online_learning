import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/model/streak.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';

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

  Future<Streak> submitQuizzes(Lesson lesson, List<String> answers) async {
    final res = await customPostRequest(
      quizAttemptsApi,
      {
        "answers": answers,
      },
      authorized: true,
    );

    if (res.statusCode == 200) {
      final streak = await addLessonStreak(lesson.id);
      return streak;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception("ጥያቄዎቹን ማረም አልተቻለም!");
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
      throw Exception("ጥያቄዎቹን ማረም አልተቻለም!");
    }
  }
}
