import '../../../core/typedef.dart';
import '../data/main_data_src.dart';
import '../data/model/course_model.dart';
import '../data/model/faq_model.dart';

abstract class MainRepo {
  FutureEither<List<CourseModel>> getCourses(
    bool isNew,
    String? key,
    String? val,
    SortingMethod method,
  );
  FutureEither<List<CourseModel>> getSavedCourses();
  FutureEither<List<CourseModel>> getStartedCourses();
  FutureEither<List<CourseModel>> getFavoriteCourses();
  FutureEither<CourseModel?> getSingleCourse(String courseId);
  FutureEither<List<String>> getUstazs();
  FutureEither<List<String>> getCategories();
  FutureEither<List<FAQModel>> getFAQ();
  FutureEither<List<CourseModel>> searchCourses(String query, int? numOfElt);
  FutureEither<int> saveCourse(CourseModel courseModel);
  FutureEither<void> deleteCourse(int id);
}
