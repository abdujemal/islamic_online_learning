import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/auth/model/confusion.dart';
import 'package:islamic_online_learning/features/auth/model/group.dart';
import 'package:islamic_online_learning/features/auth/model/const_score.dart';
import 'package:islamic_online_learning/features/auth/model/streak.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
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
      // final token = (jsonDecode(response.body))["token"];
      // print(data);
      if (data['ok'] == true &&
          data['token'] != null &&
          data['refreshToken'] != null) {
        await storage.write(
          key: 'access_token',
          value: "Bearer ${data['token']}",
        );
        await storage.write(
          key: 'refresh_token',
          value: data['refreshToken'],
        );
        await storage.write(
          key: 'phone',
          value: phone,
        );
      }
      if (user == null) {
        return {"data": data};
      } else {
        return {"user": user, "data": data};
      }
      // // print(response.body);
      // throw Exception('Failed to verifying otp');
    } else if (response.statusCode == 400) {
      throw Exception((jsonDecode(response.body))["error"]);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to verifying otp: ${response.body}');
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
      throw Exception('Failed to load groups: ${response.body}');
    }
  }

  Future<void> register(UserInput userInput) async {
    final response = await customPostRequest(
      registerApi,
      userInput.toMap(),
    );
    if (response.statusCode == 200) {
      // final data = jsonDecode(response.body) as Map<String, dynamic>;
      // return data["token"]; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to register: ${response.body}');
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
      throw Exception('Failed to get your profile: ${response.body}');
    }
  }

  Future<User> updateMyInfo(String name, int age) async {
    final dob = DateTime.now().subtract(Duration(days: age * 365));
    final response = await customPutRequest(
      updateMyInfoApi,
      {
        "name": name,
        "dob": dob.toString(),
      },
      authorized: true,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["user"];
      User user = User.fromMap(data);
      return user; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to update your profile: ${response.body}');
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
      throw Exception('Failed to get your profile: ${response.body}');
    }
  }

  Future<List<ConstScore>> getScores() async {
    final response = await customGetRequest(
      getScoresApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      List<ConstScore> score = ConstScore.listFromJson(response.body);
      return score; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to get const scores: ${response.body}');
    }
  }

  Future<List<DateTime>> getStreakFor(int month, int year) async {
    final response = await customGetRequest(
      getStreaksApi
          .replaceAll("{year}", "$year")
          .replaceAll("{month}", "$month"),
      authorized: true,
    );
    if (response.statusCode == 200) {
      final streaks = jsonDecode(response.body) as List<dynamic>;
      return streaks.map((e) => DateTime.parse(e as String)).toList(); //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to get streaks: ${response.body}');
    }
  }

  Future<int?> getUsersStreakNum() async {
    final response = await customGetRequest(
      getStreakNumApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["numOfStreaks"]; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      return null;
      // throw Exception('Failed to get streak num: ${response.body}');
    }
  }

  Future<List<Confusion>> getConfusions(int page) async {
    final response = await customGetRequest(
      "$confusionsApi?page=$page",
      authorized: true,
    );
    if (response.statusCode == 200) {
      List<Confusion> confusions = Confusion.listFromJson(response.body);
      return confusions; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to get confusions: ${response.body}');
    }
  }
}
