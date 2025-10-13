import 'dart:convert';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/model/group.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';

class AuthService {
  Future<void> sendOtpRequest(String phone) async {
    final response = await customPostRequest(
      requestOtpApi,
      {
        "phone": phone,
      },
    );

    if (response.statusCode == 200) {
      // final data = jsonDecode(response.body) as Map;
      return;
    } else if (response.statusCode == 400) {
      throw Exception(response.body);
    } else {
      final error = (jsonDecode(response.body) as Map)["error"];
      print("Response status: ${response.statusCode}");
      print("Response body: $error");

      throw Exception(error);
    }
  }

  Future<Map> verifyOtpRequest(String phone, String code) async {
    final response = await customPostRequest(
      verifyOtpApi,
      {
        "phone": phone,
        "otp": code,
      },
    );
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final data = (jsonDecode(response.body))["data"];
      final user = (jsonDecode(response.body))["user"];
      final token = (jsonDecode(response.body))["token"];
      // print(data);
      if (data != null) {
        return {"otp": data};
      } else {
        return {"user": user, "token": token};
      }
      // // print(response.body);
      // throw Exception('Failed to verifying otp');
    } else if (response.statusCode == 400) {
      throw Exception((jsonDecode(response.body))["error"]);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to verifying otp');
    }
  }

  Future<List<Group>> fetchGroups(
    int age,
    String gender,
    String timeZone,
    String curriculumId,
  ) async {
    final dob = DateTime.now().subtract(
      Duration(days: 365 * age),
    );
    final response = await customPostRequest(
      similarGroupsApi,
      {
        "dob": dob.toString(),
        "gender": gender,
        "timeZone": timeZone,
        "curriculumId": curriculumId,
      },
    );
    if (response.statusCode == 200) {
      return Group.listFromJson(response.body);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load groups');
    }
  }

  Future<String> register(UserInput userInput) async {
    final response = await customPostRequest(
      registerApi,
      userInput.toMap(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data["token"]; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to register');
    }
  }

  Future<User> getMyInfo() async {
    final response = await customGetRequest(
      getMyInfoApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      User user = User.fromJson(response.body);
      return user; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to get your profile');
    }
  }

  Future<bool> hasCourseStarted() async {
    final response = await customGetRequest(
      getMyCourseInfoApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print("course data $data");
      return data["group"]["courseStartDate"] != null; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to get your profile');
    }
  }

  Future<List<Score>> getScores() async {
    final response = await customGetRequest(
      getScoresApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      List<Score> score = Score.listFromJson(response.body);
      return score; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to get your profile');
    }
  }
}
