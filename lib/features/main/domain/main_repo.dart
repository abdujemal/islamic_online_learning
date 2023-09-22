import '../../../core/typedef.dart';
import '../data/Model/course_model.dart';

abstract class MainRepo {
  FutureEither<List<CourseModel>> getCourses(int page);
}
