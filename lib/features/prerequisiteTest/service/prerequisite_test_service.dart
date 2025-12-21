import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';

class PrerequisiteTestService {
  Future<List<Quiz>> getQuizzes(Curriculum curr) async {
    final res = await customGetRequest(
      getPrerequisiteTestApi.replaceAll("{level}", curr.level.toString()),
    );

    if (res.statusCode == 200) {
      final quizzes = Quiz.listFromJson2(res.body);
      return quizzes;
    } else {
      print("res status code ${res.statusCode}");
      print("res body ${res.body}");
      throw Exception(res.body);
    }
  }
}