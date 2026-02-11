import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/core/lib/timezone_handler.dart';
import 'package:islamic_online_learning/features/Questionaire/model/questionnaire.dart';
import 'package:islamic_online_learning/features/auth/model/city.dart';
import 'package:islamic_online_learning/features/auth/model/confusion.dart';
import 'package:islamic_online_learning/features/auth/model/curriculum_score.dart';
import 'package:islamic_online_learning/features/auth/model/group.dart';
import 'package:islamic_online_learning/features/auth/model/const_score.dart';
import 'package:islamic_online_learning/features/auth/model/user.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
  Future<void> sendOtpRequest(String phone, String ageRange) async {
    final response = await customPostRequest(
      requestOtpApi,
      {
        "phone": phone,
        "ageRange": ageRange,
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

  static GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
    // IMPORTANT: request serverAuthCode
    serverClientId: dotenv.get(
        "ANDROID_CLIENT_ID"), //"YOUR_WEB_CLIENT_ID.apps.googleusercontent.com",
  );

  Future<Map> signInWGoogle() async {
    // await _googleSignIn.signOut();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) throw Exception("googleUser is null");

    // final auth = await googleUser.authentication;

    final auth = await googleUser.authentication;
    // if (serverAuthCode == null) throw Exception("No serverAuthCode");

    // Send the code to your backendGoogleSignInAccount
    final response = await customPostRequest(
      googleAuthApi,
      {
        "idToken": auth.idToken,
      },
    );
    // final res = await http.post(
    //   Uri.parse("https://yourapi.com/auth/google"),
    //   headers: {"Content-Type": "application/json"},
    //   body: jsonEncode({
    //     "code": serverAuthCode,
    //   }),
    // );
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
          value: data['email'],
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
      throw Exception('Failed to signin with google: ${response.body}');
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
    String city,
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
        "city": city,
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
    final timeZone = await getDeviceTimeZone();
    final response = await customPostRequest(
      registerApi,
      {
        ...userInput.toMap(),
        'timeZone': timeZone,
      },
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

  Future<List<Questionnaire>> getActiveQuestionnaire() async {
    final response = await customGetRequest(
      getActiveQuestionnaireApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      List<Questionnaire> questionnaires =
          Questionnaire.listFromJson(response.body);
      return questionnaires; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to get active questionnaire: ${response.body}');
    }
  }

  Future<List<City>> searchCities(String q) async {
    final userName = dotenv.get("GEONAMES_USER");

    final res = await customGetRequest(
        "https://secure.geonames.org/searchJSON?q=${q}&maxRows=10&featureClass=P&username=${userName}");

    if (res.statusCode != 200) {
      throw Exception('Failed to load cities');
    }

    final List data = jsonDecode(res.body)["geonames"];
    return data.map((e) => City.fromJson(e)).toList();
  }

  Future<void> submitQuestionnaire(Map<String, dynamic> data) async {
    final response = await customPostRequest(
      submitFeedbackApi,
      data,
      authorized: true,
    );

    if (response.statusCode == 200) {
      // List<Questionnaire> questionnaires =
      //     Questionnaire.listFromJson(response.body);
      // return questionnaires; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to submit questionnaire: ${response.body}');
    }
  }

  Future<void> submitFeedback(String text, int? lessonNum) async {
    final response = await customPostRequest(
      submitFeedbackApi,
      {
        "text": text,
        if (lessonNum != null) ...{
          "lessonNum": lessonNum,
        }
      },
      authorized: true,
    );

    if (response.statusCode == 200) {
      // List<Questionnaire> questionnaires =
      //     Questionnaire.listFromJson(response.body);
      // return questionnaires; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to submit feedback: ${response.body}');
    }
  }

  Future<User> updateMyInfo(String name,) async {
    final response = await customPutRequest(
      updateMyInfoApi,
      {
        "name": name,
        
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
      return streaks
          .map((e) => DateTime.parse(e as String).toLocal())
          .toList(); //token
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

  Future<List<CurriculumScore>> getCertificates() async {
    final response = await customGetRequest(
      getMyCertificateApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      List<CurriculumScore> curriculumScores =
          CurriculumScore.listFromJson(response.body);
      return curriculumScores; //token
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to get curriculumScores: ${response.body}');
    }
  }

  Future<void> deleteMyProfile() async {
    final response = await customDeleteRequest(
      deleteMyAccountApi,
      {},
      authorized: true,
    );
    if (response.statusCode == 200) {
      // Successfully deleted account
      print("Account deleted successfully");
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to delete account: ${response.body}');
    }
  }
}
