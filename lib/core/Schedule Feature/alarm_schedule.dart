// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void startAlarm() async {
  // Schedule the alarm to trigger after a specific delay (e.g., 5 seconds)
  // await AndroidAlarmManager.oneShot(
  //   const Duration(seconds: 5),
  //   0,
  //   showOverlay,
  //   wakeup: true,
  // );
}

void showOverlay() async {
  // Initialize the Flutter app
  WidgetsFlutterBinding.ensureInitialized();

  // Create an overlay window
  // await FlutterOverlayWindow.create(
  //   // Specify the widget you want to display as the overlay
  //   overlayWidgetBuilder: (context) {
  //     return Center(
  //       child: Container(
  //         width: 200,
  //         height: 200,
  //         color: Colors.red,
  //         child: Text(
  //           'Overlay',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 20,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ),
  //     );
  //   },
  // );

  // Run the Flutter app
  // await FlutterOverlayWindow.showOverlay();
}
