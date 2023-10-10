import '../../../core/typedef.dart';
import '../data/course_model.dart';

abstract class MainRepo {
  FutureEither<List<CourseModel>> getCourses(bool isNew);
  FutureEither<List<CourseModel>> getCoursesHistory();
  FutureEither<List<CourseModel>> getFavoriteCourses();
  FutureEither<List<CourseModel>> getDownloadedCourses();
  FutureEither<List<String>> getUstazs();
  FutureEither<List<String>> getCategories();
}