import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
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
        NotificationChannel(
          channelKey: 'ders_app_alarm',
          channelName: 'Ders App Alarm Channel',
          channelDescription: 'Ders app Alarm',
          defaultColor: primaryColor,
          importance: NotificationImportance.Max,
          ledColor: primaryColor,
          playSound: true,
          // soundSource: 'asset://assets/alarm.wav',
          // onlyAlertOnce: false,
          enableVibration: true,
          enableLights: true,
        ),
      ],
    );
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime dateTime) async {
    // Create a notification content
    // final content = NotificationContent(
    //   id: id,
    //   channelKey: 'ders_app',
    //   title: title,
    //   body: body,
    //   // payload: {'data': 'your_custom_data'},
    //   locked: true,
    // );
    // Schedule the notification
    // AwesomeNotifications().createNotification(
    //   content: content,
    //   schedule: NotificationAndroidCrontab()
    // NotificationInterval(
    //   interval: 86400, //means daily
    //   repeats: true,
    //   // initialDateTime: DateTime.now().add(Duration(seconds: 5)),
    //   // time: Time(12, 0, 0),
    // ),
    // autoCancel: false,
    // displayOnForeground: true,
    // );
    // await AndroidAlarmManager.oneShot(
    //     const Duration(seconds: 20), 1, printHello);

    final content = NotificationContent(
      id: 1,
      channelKey: 'ders_app_alarm',
      title: title,
      body: body,
      category: NotificationCategory.Alarm,
      wakeUpScreen: true,
    );

    await AwesomeNotifications().createNotification(
        content: content,
        // actionButtons: [action1, action2],
        schedule: NotificationInterval(interval: dateTime.second));

    // AwesomeNotifications().actionStream.listen((receivedNotification) {
    //   if (receivedNotification.actionKey == 'ACTION_ONE' ||
    //       receivedNotification.actionKey == 'ACTION_TWO') {
    //     AwesomeNotifications().stopSound();
    //   }
    // });
  }

  void showImmediateNotification() {
    final content = NotificationContent(
      id: 1,
      channelKey: 'scheduled_channel',
      title: 'Immediate Notification',
      body: 'This is an immediate notification!',
      // payload: {'key': 'value'},
      notificationLayout: NotificationLayout.Default,
      locked: true,
      // autoCancel: false,
      // sound: RawResourceAndroidNotificationSound('notification_sound'),
      // actionButtons: [
      //   NotificationActionButton(
      //     key: 'clear',
      //     label: 'Clear',
      //     autoCancel: true,
      //   ),
      // ],
    );

    AwesomeNotifications().createNotification(content: content);
  }

  void scheduleWeeklyNotification() {
    // final content = NotificationContent(
    //   id: 0,
    //   channelKey: 'scheduled_channel',
    //   title: 'Weekly Notification',
    //   body: 'This is a weekly notification!',
    //   payload: {'key': 'value'},
    //   notificationLayout: NotificationLayout.Default,
    // );

    // final schedule = WeeklySchedule(
    //   weekday: DayOfWeek.Monday,
    //   hour: 10,
    //   minute: 0,
    //   second: 0,
    // );

    // AwesomeNotifications().createNotification(
    //   content: content,
    //   schedule: schedule,
    // );
  }
}

@pragma('vm:entry-point')
printHello() async {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=$isolateId");

  // AwesomeNotifications().createNotification(
  //   content: NotificationContent(
  //     id: 0,
  //     channelKey: "ders_app_alarm",
  //     title: "Alarm",
  //     body: "Alarm",
  //   ),
  //   schedule: NotificationInterval(
  //     interval: 0, //means daily
  //     repeats: true,
  //     // initialDateTime: DateTime.now().add(Duration(seconds: 5)),
  //     // time: Time(12, 0, 0),
  //   ),
  // );

  FlutterAlarmClock.createAlarm(
    hour: 0,
    minutes: 0,
  );

  // final pref = await SharedPreferences.getInstance();
  // pref.setString("ScheduleTitle", value)
  // FlutterOverlayWindow.showOverlay();

  // WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load();
  // // await AndroidAlarmManager.initialize();
  // await DatabaseHelper().initializeDatabase();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await Schedule().init();
  // runApp(const ProviderScope(child: Main()));
}
