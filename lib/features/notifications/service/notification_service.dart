import 'dart:convert';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/features/notifications/model/notification.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotifications({int page = 1}) async {
    final response = await customGetRequest(
      "$notificationsApi?page=$page",
      authorized: true,
    );
    if (response.statusCode == 200) {
      return NotificationModel.listFromJson(response.body);
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to load notifications: ${response.body}');
    }
  }

  Future<int> readNotifications() async {
    final response = await customGetRequest(
      readNotificationsApi,
      authorized: true,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)["notificationsRead"] as int;
    } else {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception('Failed to read notifications: ${response.body}');
    }
  }

  
}
