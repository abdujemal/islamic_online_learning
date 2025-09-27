import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';

class CurriculumService {
  Future<List<Curriculum>> fetchCurriculums() async {
    final response = await customGetRequest(curriculumApi);

    if (response.statusCode == 200) {
      return Curriculum.listFromJson(response.body);
    } else {
      throw Exception('Failed to load curriculum');
    }
  }
}
