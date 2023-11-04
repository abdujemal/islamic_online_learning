import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:islamic_online_learning/core/constants.dart';

class Schedule {
  Future<void> init() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'ders_app',
          channelName: 'Ders App Channel',
          channelDescription: 'Ders app',
          defaultColor: primaryColor,
          ledColor: primaryColor,
        ),
      ],
    );
  }

  void scheduleNotification(int id, String title, String body) async {
    // Create a notification content
    final content = NotificationContent(
      id: id,
      channelKey: 'ders_app',
      title: title,
      body: body,
      // payload: {'data': 'your_custom_data'},
      locked: true,
    );

    // Schedule the notification
    AwesomeNotifications().createNotification(
      content: content,
      schedule: NotificationAndroidCrontab()
      // NotificationInterval(
      //   interval: 86400, //means daily
      //   repeats: true,
      //   // initialDateTime: DateTime.now().add(Duration(seconds: 5)),
      //   // time: Time(12, 0, 0),
      // ),
      // autoCancel: false,
      // displayOnForeground: true,
    );
  }
}
