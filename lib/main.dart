import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Schedule%20Feature/schedule.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/download_database.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'features/main/presentation/pages/main_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/ic_launcher',
  );
  //await DatabaseHelper().initializeDatabase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Schedule().init();

  runApp(
    const ProviderScope(
      child: Main(),
    ),
  );
}

// void handleIncomingIntent() async {
//   final initialUri = await getInitialUri(); // Use a library to get the initial URL
//   if (initialUri != null && initialUri.scheme == 'your-app') {
//     final courseId = int.parse(initialUri.pathSegments.last);
//     // Navigate to the course page with the extracted ID
//   }
// }

class Main extends ConsumerStatefulWidget {
  // final PendingDynamicLinkData? initialLink;
  const Main({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  FirebaseDynamicLinks firebaseDynamicLink = FirebaseDynamicLinks.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final themeMode = ref.watch(themeProvider);
      final fontScale = ref.watch(fontScaleProvider);
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(fontScale),
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
              // cardColor: Theme.of(context).dialogTheme.backgroundColor,
              colorScheme: const ColorScheme.dark(
                primary: primaryColor,
                background: Color.fromARGB(255, 51, 51, 51),
              ),
              dialogTheme: const DialogTheme(
                backgroundColor: darkCardColor,
              ),
              cardColor: darkCardColor,
              listTileTheme: const ListTileThemeData(
                titleTextStyle: TextStyle(
                  fontSize: 16,
                ),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: darkCardColor,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                // primarySwatch: primaryColor,
                // listTileTheme: const ListTileThemeData(
                //   titleTextStyle: TextStyle(
                //     fontSize: 16,
                //   ),
                // ),
                // actionsIconTheme: IconThemeData(
                //   color: primaryColor,
                // ),
                elevation: 2,
              )
              // colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
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
            colorScheme: const ColorScheme.light(primary: primaryColor),
            scaffoldBackgroundColor: const Color.fromARGB(255, 240, 240, 240),
            appBarTheme: const AppBarTheme(
              backgroundColor: cardColor,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              // primarySwatch: primaryColor,
              // listTileTheme: const ListTileThemeData(
              //   titleTextStyle: TextStyle(
              //     fontSize: 16,
              //   ),
              // ),
              // actionsIconTheme: IconThemeData(
              //   color: primaryColor,
              // ),
              elevation: 2,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            ),
          ),
          home: FutureBuilder(
              future: checkDb(),
              builder: (context, snap) {
                if (snap.data == null) {
                  return Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 100,
                            width: 100,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const CircularProgressIndicator()
                        ],
                      ),
                    ),
                  );
                }
                return snap.data! ? const MainPage() : const DownloadDatabase();
              }),
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

Future<int?> getFileSize(String url) async {
  final request = await HttpClient().headUrl(Uri.parse(url));
  final response = await request.close();
  if (response.statusCode == HttpStatus.ok) {
    final contentLength = response.contentLength;
    return contentLength;
  }
  throw Exception('Failed to get audio file size');
}

Future<bool> checkDb() async {
  Directory directory = await getApplicationSupportDirectory();
  String path = '${directory.path}$dbPath';
  if (File(path).existsSync()) {
    // print("file exists");
    // print("local len: ${File(path).lengthSync()}");
    // int? size = await getFileSize(databaseUrl);
    // print(size);
    // if (size == null) {
    //   return false;
    // }

    return true; //size == File(path).lengthSync();
  } else {
    return false;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
