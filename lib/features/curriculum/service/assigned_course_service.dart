import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';

class AssignedCourseService {
  Future<List<Lesson>> fetchLessonsOfAssignedCourses(String courseId) async {
    final response = await customGetRequest(
      lessonsApi.replaceFirst(":courseId", courseId),
      authorized: true,
    );

    if (response.statusCode == 200) {
      return Lesson.listFromJson(response.body);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load lessons of an assigned course: ${response.body}');
    }
  }
}
