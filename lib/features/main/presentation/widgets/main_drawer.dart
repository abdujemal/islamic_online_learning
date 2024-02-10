import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/aboutus.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/faq.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

import '../../../downloadedFiles/presentation/pages/downloaded_files_page.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  bool notification = false;

  bool guide = false;

  bool beginner = true;

  double fnt = 14;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      ref.read(sharedPrefProvider).then((pref) {
        bool isSubed = pref.getBool("isSubed") ?? true;
        setState(() {
          notification = isSubed;
        });
      });

      ref.read(sharedPrefProvider).then((pref) {
        bool show = pref.getString("showGuide") == "true,true";

        setState(() {
          guide = show;
        });
      });

      ref.read(sharedPrefProvider).then((pref) {
        bool? show = pref.getBool("showBeginner");
        print(show);
        ref.read(showBeginnerProvider.notifier).update((state) => show ?? true);
        setState(() {
          beginner = show ?? true;
        });
      });
    }
    // Future.delayed(const Duration(seconds: 1)).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 100,
          ),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: primaryColor,
            image: DecorationImage(
              image: AssetImage(
                'assets/bg.png',
              ),
              fit: BoxFit.fill,
              opacity: .4,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "ዒልም ፈላጊ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Consumer(builder: (context, ref, _) {
                final theme = ref.watch(themeProvider);
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).chipTheme.backgroundColor!,
                      ),
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      ref.read(mainNotifierProvider.notifier).changeTheme(
                            theme == ThemeMode.dark
                                ? ThemeMode.light
                                : ThemeMode.dark,
                          );
                    },
                    leading: Icon(theme == ThemeMode.dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded),
                    title: Text(
                      theme == ThemeMode.dark ? "ብርሃን" : "ምሽት",
                      style: TextStyle(
                        fontSize: fnt,
                      ),
                    ),
                  ),
                );
              }),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Theme.of(context).chipTheme.backgroundColor != null
                        ? BorderSide(
                            color: Theme.of(context).chipTheme.backgroundColor!,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const DownloadedFilesPage(),
                      ),
                    );
                  },
                  leading: const Icon(Icons.download_rounded),
                  title: Text(
                    "ዳውንሎድ የተደረጉ ፋይሎች",
                    style: TextStyle(
                      fontSize: fnt,
                    ),
                  ),
                ),
              ),
              // fontScale
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Theme.of(context).chipTheme.backgroundColor != null
                        ? BorderSide(
                            color: Theme.of(context).chipTheme.backgroundColor!,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: Consumer(builder: (context, ref, _) {
                  final fontScale = ref.watch(fontScaleProvider);
                  return ListTile(
                    leading: const Icon(Icons.font_download_rounded),
                    title: Text(
                      "የፅሁፍ መጠን",
                      style: TextStyle(
                        fontSize: fnt,
                      ),
                    ),
                    subtitle: Slider(
                      divisions: 3,
                      activeColor: primaryColor,
                      min: 1,
                      max: 1.3,
                      value: fontScale,
                      onChanged: (v) async {
                        if (kDebugMode) {
                          print(v);
                        }
                        ref
                            .read(fontScaleProvider.notifier)
                            .update((state) => v);
                        final pref = await ref.read(sharedPrefProvider);
                        pref.setDouble('fontScale', v);
                      },
                    ),
                  );
                }),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Theme.of(context).chipTheme.backgroundColor != null
                        ? BorderSide(
                            color: Theme.of(context).chipTheme.backgroundColor!,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.help_rounded),
                  title: Text(
                    "የአፑን አጠቃቀም አሳየኝ",
                    style: TextStyle(
                      fontSize: fnt,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                    value: guide,
                    activeColor: primaryColor,
                    onChanged: (v) async {
                      setState(() {
                        guide = v;
                      });
                      final pref = await ref.read(sharedPrefProvider);
                      pref.setString(
                          "showGuide", v ? "true,true" : "false,false");
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Theme.of(context).chipTheme.backgroundColor != null
                        ? BorderSide(
                            color: Theme.of(context).chipTheme.backgroundColor!,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(
                    "የጀማሪ ደርሶችን አሳየኝ",
                    style: TextStyle(
                      fontSize: fnt,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                    value: beginner,
                    activeColor: primaryColor,
                    onChanged: (v) async {
                      setState(() {
                        beginner = v;
                      });
                      ref
                          .read(showBeginnerProvider.notifier)
                          .update((state) => v);

                      final pref = await ref.read(sharedPrefProvider);
                      pref.setBool("showBeginner", v);
                    },
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Theme.of(context).chipTheme.backgroundColor != null
                        ? BorderSide(
                            color: Theme.of(context).chipTheme.backgroundColor!,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.notifications_rounded),
                  title: Text(
                    "አድስ ደርስ ሲገባ መልእክት ይግባልኝ",
                    style: TextStyle(
                      fontSize: fnt,
                    ),
                  ),
                  trailing: CupertinoSwitch(
                    activeColor: primaryColor,
                    value: notification,
                    onChanged: (v) async {
                      setState(() {
                        notification = v;
                      });
                      final pref = await ref.read(sharedPrefProvider);
                      pref.setBool("isSubed", v);
                      if (v) {
                        AwesomeNotifications()
                            .isNotificationAllowed()
                            .then((isAllowed) {
                          if (!isAllowed) {
                            AwesomeNotifications()
                                .requestPermissionToSendNotifications();
                          }
                        });
                        ref
                            .read(firebaseMessagingProvider)
                            .subscribeToTopic("ders");
                      } else {
                        ref
                            .read(firebaseMessagingProvider)
                            .unsubscribeFromTopic("ders");
                      }
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Theme.of(context).chipTheme.backgroundColor != null
                        ? BorderSide(
                            color: Theme.of(context).chipTheme.backgroundColor!,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  leading: const Icon(Icons.share_rounded),
                  title: Text(
                    "አጋራ",
                    style: TextStyle(
                      fontSize: fnt,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Theme.of(context).chipTheme.backgroundColor != null
                        ? BorderSide(
                            color: Theme.of(context).chipTheme.backgroundColor!,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const FAQ(),
                      ),
                    );
                  },
                  leading: const Icon(Icons.help_rounded),
                  title: Text(
                    "ስለ አፑ የተጠየቁ ጥያቄዎች",
                    style: TextStyle(
                      fontSize: fnt,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Theme.of(context).chipTheme.backgroundColor != null
                        ? BorderSide(
                            color: Theme.of(context).chipTheme.backgroundColor!,
                          )
                        : BorderSide.none,
                  ),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const AboutUs(),
                      ),
                    );
                  },
                  leading: const Icon(Icons.info_rounded),
                  title: Text(
                    "ስለ አፑ",
                    style: TextStyle(
                      fontSize: fnt,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
