import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:islamic_online_learning/core/constants.dart';

class Schedule {
  Future<void> init() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'ilm_felagi',
          channelName: 'ዒልም ፈላጊ',
          channelDescription: 'Ders app',
          defaultColor: primaryColor,
          ledColor: primaryColor,
          // icon: 'mipmap/launcher_icon',
        ),
        NotificationChannel(
          channelKey: 'ilm_felagi_alarm',
          channelName: 'ዒልም ፈላጊ አስታዋሽ',
          channelDescription: 'Ders app Alarm',
          defaultColor: primaryColor,
          importance: NotificationImportance.Max,
          ledColor: primaryColor,
          // playSound: true,
          soundSource: "resource://raw/alarm",
          // onlyAlertOnce: false,
          // icon: 'mipmap/launcher_icon',
          // defaultRingtoneType: DefaultRingtoneType.Alarm,

          enableVibration: true,
          enableLights: true,
          criticalAlerts: true,
        ),
      ],
    );
  }

  Future<void> deleteNotification(int id, List<int> weekDays) async {
    for (int weekDay in weekDays) {
      await AwesomeNotifications().cancel((weekDay * 1000000) + id);
    }
  }

  Future<void> scheduleNotification(int id, String title, String body,
      DateTime dateTime, List<int> weekDays) async {
    print("today: ${DateTime.now().weekday}");

    for (int weekDay in weekDays) {
      print(weekDay);

      final content = NotificationContent(
        id: (weekDay * 1000000) + id,
        channelKey: 'ilm_felagi_alarm',
        title: title,
        body: body,
        category: NotificationCategory.Alarm,
        autoDismissible: false,
        wakeUpScreen: true,
      );

      await AwesomeNotifications().createNotification(
        content: content,
        actionButtons: [
          NotificationActionButton(
            key: 'stop',
            label: 'አጥፋ',
            actionType: ActionType.KeepOnTop,
            enabled: true,
          ),
          NotificationActionButton(
            key: 'open',
            label: 'ክፈት',
            actionType: ActionType.Default,
            enabled: true,
          ),
        ],
        schedule: NotificationCalendar(
          allowWhileIdle: true,
          preciseAlarm: true,
          repeats: true,
          weekday: weekDay,
          hour: dateTime.hour,
          minute: dateTime.minute,
          second: dateTime.second,
        ),
      );
    }
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
    );

    AwesomeNotifications().createNotification(content: content);
  }
}
