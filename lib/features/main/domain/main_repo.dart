import '../../../core/typedef.dart';
import '../data/course_model.dart';

abstract class MainRepo {
  FutureEither<List<CourseModel>> getCourses(int page);
}