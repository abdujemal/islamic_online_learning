import 'dart:async';
// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Schedule%20Feature/schedule.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';

// import 'features/courseDetail/presentation/widgets/delete_confirmation.dart';
import 'features/main/presentation/pages/main_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/book',
  );
  await dotenv.load();
  await AndroidAlarmManager.initialize();
  await DatabaseHelper().initializeDatabase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Schedule().init();
  runApp(const ProviderScope(child: Main()));
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final themeMode = ref.watch(themeProvider);
      final fontScale = ref.watch(fontScaleProvider);
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: fontScale,
        ),
        child: MaterialApp(
          title: "ዒልም ፈላጊ",
          color: primaryColor,
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          darkTheme: ThemeData.dark().copyWith(
            chipTheme: ChipThemeData(
              backgroundColor: Colors.grey.shade700,
            ),
            dividerColor: Colors.white38,
            
          ),
          theme: ThemeData(
            dividerColor: Colors.black45,
            chipTheme: const ChipThemeData(
              backgroundColor: Color.fromARGB(255, 207, 207, 207),
            ),
            dialogTheme: const DialogTheme(
              backgroundColor: cardColor,
            ),
            cardColor: cardColor,
            primarySwatch: primaryColor,
            scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
            appBarTheme: const AppBarTheme(
              backgroundColor: cardColor,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              // actionsIconTheme: IconThemeData(
              //   color: primaryColor,
              // ),
              elevation: 2,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
          home: const MainPage(),
        ),
      );
    });
  }
}

// overlay entry point
// @pragma("vm:entry-point")
// void overlayMain() {
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Material(
//         child: DeleteConfirmation(
//           title: "title",
//           action: () async {
//             // await FlutterOverlayWindow.closeOverlay();
//           },
//         ),
//       ),
//     ),
//   );
// }
