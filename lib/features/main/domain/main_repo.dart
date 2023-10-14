import '../../../core/typedef.dart';
import '../data/course_model.dart';

abstract class MainRepo {
  FutureEither<List<CourseModel>> getCourses(
    bool isNew,
    String? key,
    String? val,
  );
  FutureEither<List<CourseModel>> getCoursesHistory();
  FutureEither<List<CourseModel>> getFavoriteCourses();
  FutureEither<List<CourseModel>> getDownloadedCourses();
  FutureEither<List<String>> getUstazs();
  FutureEither<List<String>> getCategories();
  FutureEither<List<CourseModel>> searchCourses(String query, int? numOfElt);
  FutureEither<int> saveCourse(CourseModel courseModel);
  FutureEither<void> deleteCourse(int id);
}
