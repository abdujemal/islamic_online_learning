import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Schedule%20Feature/schedule.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/course_detail.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'features/main/presentation/pages/main_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/ic_launcher',
  );
  await DatabaseHelper().initializeDatabase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Schedule().init();

  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  runApp(
    ProviderScope(
      child: Main(
        initialLink: initialLink,
      ),
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
  final PendingDynamicLinkData? initialLink;
  const Main({required this.initialLink, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  FirebaseDynamicLinks firebaseDynamicLink = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print("link:- ${widget.initialLink?.link}");
      print("Segments: ${widget.initialLink?.link.pathSegments}");
      if (widget.initialLink?.link.pathSegments.contains("courses") ?? false) {
        String id = Uri.decodeFull(widget.initialLink?.link.toString() ?? "")
            .split("/")
            .last
            .replaceAll("courses?id=", "")
            .replaceAll("+", " ");
        print("id: $id");
        // String? id = widget.initialLink!.link.queryParameters["id"];

        getCourseAndRedirect(id);
      }
    });

    // firebaseDynamicLink.onLink.listen((event) {
    //   print("link:- ${event.link}");
    //   print("Segments: ${event.link.pathSegments}");
    //   if (event.link.pathSegments.contains("courses")) {
    // String id = Uri.decodeFull(event.link.toString())
    //     .split("/")
    //     .last
    //     .replaceAll("courses?id=", "")
    //     .replaceAll("+", " ");
    // print("id: $id");

    //     getCourseAndRedirect(id);
    //   }
    // }).onError((e) {
    //   toast(
    //     e.toString(),
    //     ToastType.error,
    //     context,
    //     isLong: true,
    //   );
    // });
  }

  getCourseAndRedirect(String? id) async {
    print("course id:$id");
    if (id == null) {
      return;
    }
    if (id.isEmpty) {
      return;
    }
    final res = await ref
        .read(mainNotifierProvider.notifier)
        .getSingleCourse(id, context, fromCloud: true);
    print("wait ... ");
    if (res != null) {
      print("redirecting ... ");
      if (mounted) {
        print("go");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetail(cm: res),
          ),
        );
      }
    }
  }

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
