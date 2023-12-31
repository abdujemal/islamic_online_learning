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
        bool show = pref.getBool("showGuide") ?? true;
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 10,
                right: 5,
                left: 5,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: const Center(
                child: Text(
                  "ዒልም ፈላጊ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
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
                        title: Text(theme == ThemeMode.dark ? "ብርሃን" : "ምሽት"),
                      ),
                    );
                  }),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).chipTheme.backgroundColor!,
                        ),
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
                      title: const Text("ዳውንሎድ የተደረጉ ፋይሎች"),
                    ),
                  ),
                  // fontScale
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).chipTheme.backgroundColor!,
                        ),
                      ),
                    ),
                    child: Consumer(builder: (context, ref, _) {
                      final fontScale = ref.watch(fontScaleProvider);
                      return ListTile(
                        leading: const Icon(Icons.font_download_rounded),
                        title: const Text("የጹሁፍ መጠን"),
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
                        bottom: BorderSide(
                          color: Theme.of(context).chipTheme.backgroundColor!,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.help_rounded),
                      title: const Text("የአፑን አጠቃቅም አሳየኝ"),
                      trailing: CupertinoSwitch(
                        value: guide,
                        activeColor: primaryColor,
                        onChanged: (v) async {
                          setState(() {
                            guide = v;
                          });
                          final pref = await ref.read(sharedPrefProvider);
                          pref.setBool("showGuide", v);
                        },
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).chipTheme.backgroundColor!,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: const Text("የጀማሪ ደርሶችን አሳየኝ"),
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
                        bottom: BorderSide(
                          color: Theme.of(context).chipTheme.backgroundColor!,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_rounded),
                      title: const Text("አዲስ ደርስ ሲገባ መልክት ይግባልኝ"),
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
                        bottom: BorderSide(
                          color: Theme.of(context).chipTheme.backgroundColor!,
                        ),
                      ),
                    ),
                    child: const ListTile(
                      leading: Icon(Icons.share_rounded),
                      title: Text("አጋራ"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).chipTheme.backgroundColor!,
                        ),
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
                      title: const Text("ስለ አፑ የተጠየቁ ጥያቄዎች"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).chipTheme.backgroundColor!,
                        ),
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
                      title: const Text("ስለ እኛ"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
