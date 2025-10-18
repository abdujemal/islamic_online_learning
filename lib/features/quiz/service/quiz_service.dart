import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
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
      throw Exception("ጥያቄዎቹን ማግኘት አልተቻለም!");
    }
  }

  Future<List<Quiz>> submitQuizzes(
      Lesson lesson, List<Map<String, dynamic>> answers) async {
    for (Map<String, dynamic> ans in answers) {
      await customPostRequest(
        quizAttemptsApi,
        ans,
        authorized: true,
      );
    }

    if (res.statusCode == 200) {
      final quizzes = Quiz.listFromJson(res.body);
      return quizzes;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception("ጥያቄዎቹን ማግኘት አልተቻለም!");
    }
  }
}
