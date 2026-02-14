import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/model/streak.dart';
import 'package:islamic_online_learning/features/quiz/model/question.dart';
import 'package:islamic_online_learning/features/quiz/model/quiz.dart';
import 'package:islamic_online_learning/features/quiz/service/quiz_service.dart';
import 'package:islamic_online_learning/features/meeting/model/discussion.dart';

final voiceRoomServiceProvider = Provider<VoiceRoomService>((ref) {
  return VoiceRoomService();
});

class VoiceRoomService {
  Future<Discussion> createDiscussion(String title, int fromLesson) async {
    final res = await customPostRequest(
      discussionsApi,
      {
        "title": title,
        "fromLesson": fromLesson,
      },
      authorized: true,
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create discussion: ${res.body}');
    }
    return Discussion.fromJson(res.body);
  }

  Future<List<Quiz>> getQuizzesForDiscussion() async {
    final res = await customGetRequest(
      discussionQuizzesApi,
      authorized: true,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to load quizzes: ${res.body}');
    }
    return Quiz.listFromJson2(res.body);
  }

  Future<List<Question>> getQuestionsForDiscussion() async {
    final res = await customGetRequest(
      discussionQuestionsApi,
      authorized: true,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to load questions: ${res.body}');
    }
    return Question.listFromJson(res.body);
  }

  Future<void> callAdmin() async {
    final res = await customPostRequest(
      callAdminsApi,
      {},
      authorized: true,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to callAdmins: ${res.body}');
    }
  }

  Future<StreakWNo> submitDiscussionTasks(
      List<QA> qas, List<QuizAns> quizAns) async {
    final res = await customPostRequest(
      submitDiscussionTasksApi,
      {
        "questionAttempts": qas.map((e) => e.toMap()).toList(),
        "quizIds": quizAns.map((e) => e.quizId).toList(),
        "answers": quizAns.map((e) => e.answer).toList(),
      },
      authorized: true,
    );
    if (res.statusCode == 200) {
      final streak = StreakWNo.fromJson(res.body);
      return streak;
    } else {
      throw Exception('Failed to submit discussion tasks: ${res.body}');
    }
    // return Question.listFromJson(res.body);
  }
}
