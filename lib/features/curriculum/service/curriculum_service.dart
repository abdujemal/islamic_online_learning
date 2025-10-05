import 'dart:convert';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/curriculum/model/curriculum.dart';

class CurriculumService {
  Future<List<Curriculum>> fetchCurriculums() async {
    final response = await customGetRequest(curriculumsApi);

    if (response.statusCode == 200) {
      return Curriculum.listFromJson(response.body);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load curriculum');
    }
  }

  Future<Curriculum> fetchCurriculum() async {
    final response = await customGetRequest(
      getCurriculumApi,
      authorized: true,
    );

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body) as Map<String, dynamic>;
      return Curriculum.fromMap(parsed["currentCurriculum"]);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load curriculum');
    }
  }
}
