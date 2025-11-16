import 'dart:async';

import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/playlist_helper.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/core/update_checker.dart';
import 'package:islamic_online_learning/features/auth/view/pages/account_tab.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/pages/curriculum_tab.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/fav.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/home.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/bottom_nav.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/main_drawer.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/rate_us_dailog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/Audio Feature/current_audio_view.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late TabController _tabController;

  int i = 0;

  final GlobalKey _searchIconKey = GlobalKey();
  final GlobalKey _courseTitleKey = GlobalKey();
  final GlobalKey _courseCategoryKey = GlobalKey();
  final GlobalKey _courseUstazKey = GlobalKey();

  final GlobalKey _menuKey = GlobalKey();
  // final GlobalKey _courseNameKey = GlobalKey();
  // final GlobalKey _courseUstaz = GlobalKey();
  // final GlobalKey _courseCategory = GlobalKey();
  // final GlobalKey _bookmarkey = GlobalKey();

  bool show = false;

  bool showOnes = true;

  bool showTopAudio = false;

  bool? wantToRate;

  Timer? searchTimer;

  // StateController<int>? menuIndexWatch;

  void refChangeHandler(int state) {
    _tabController.animateTo(state);
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    FirebaseMessaging.instance.subscribeToTopic("v1.0.1");

    _tabController.addListener(_handleTabChange);

    if (FirebaseAuth.instance.currentUser == null) {
      FirebaseAuth.instance.signInAnonymously().then((value) {
        toast("እንኳን ደህና መጡ!", ToastType.success, context);
      });
    }

    if (mounted) {
      ref.read(mainNotifierProvider.notifier).getTheme();
      ref.read(sharedPrefProvider).then((pref) {
        wantToRate = pref.getBool(PrefConsts.wantToRate);
        ref.read(fontScaleProvider.notifier).update(
              (state) => pref.getDouble(PrefConsts.fontScale) ?? 1.0,
            );
      });

      ref.read(sharedPrefProvider).then((pref) {
        ref.read(showGuideProvider.notifier).update(
          (state) {
            show = bool.parse(
                pref.getString(PrefConsts.showGuide)?.split(",").first ??
                    "true");
            return [
              show,
              bool.parse(
                  pref.getString(PrefConsts.showGuide)?.split(",").last ??
                      "true")
            ];
          },
        );
      });

      ref.read(sharedPrefProvider).then((pref) {
        bool isSubed = pref.getBool(PrefConsts.isSubed) ?? true;
        if (isSubed) {
          FirebaseMessaging.instance.subscribeToTopic("ders");
        }
      });

      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   menuIndexWatch = ref.watch(menuIndexProvider.notifier);
      //   menuIndexWatch?.addListener(refChangeHandler);
      // });

      AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        final mainState = ref.read(mainNotifierProvider.notifier);
        // updates

        mainState.addListener((state) {
          if (!state.isLoading && state.courses.isNotEmpty) {
            if (mounted) {
              bool isOnCurrentPage = !Navigator.canPop(context);
              if (isOnCurrentPage) {
                if (show) {
                  if (showOnes) {
                    showTutorial();
                    showOnes = false;
                  }
                }
              }
            }
          }

          // state.mapOrNull(loaded: (_) {
          //   // showDialog(
          //   //   context: context,
          //   //   builder: (context) => UpdateAllCourses(
          //   //     _.courses,
          //   //   ),
          //   // );
          // });
        });
      }
    });
  }

  showTutorial() {
    List<TargetFocus> targets = [
      getTutorial(
        key: _searchIconKey,
        identify: "SearchButton",
        align: ContentAlign.bottom,
        title: "የሰርች ቁልፍ",
        subtitle: "ይህንን ቁልፍ ነክተው ደርሶችን በስም መፈለግ ይችላሉ።",
      ),
      getTutorial(
        key: _menuKey,
        identify: "MenuButton",
        align: ContentAlign.bottom,
        title: "የማስተካከያዎች ቁልፍ",
        subtitle: "ይህንን ቁልፍ ነክተው የተለያዩ ማስተከያዎችን ማግኘት ይችላሉ።",
      ),
      getTutorial(
        key: _courseTitleKey,
        identify: "CourseTitle",
        align: ContentAlign.bottom,
        title: "የደርሱ ስም",
        subtitle: "የደርሱን ስም ለሁለት ሰከንድ ጫን ካሉት ተመሳሳይ ስም ያላቸውን ደርሶች ያመጣሎታል።",
      ),
      getTutorial(
        key: _courseUstazKey,
        identify: "CourseUstaz",
        align: ContentAlign.bottom,
        title: "የደርሱ ኡስታዝ",
        subtitle:
            "የደርሱን ኡስታዝ ስም ለሁለት ሰከንድ ጫን ካሉት ተመሳሳይ ኡስታዝ ስም ያላቸውን ደርሶች ያመጣሎታል።",
      ),
      getTutorial(
        key: _courseCategoryKey,
        identify: "CourseCategory",
        align: ContentAlign.bottom,
        title: "የደርሱ ምድብ",
        subtitle: "የደርሱን ምድብ ለሁለት ሰከንድ ጫን ካሉት ተመሳሳይ ምድብ የሆኑ ደርሶች ያመጣሎታል።",
      ),
    ];

    if (show) {
      TutorialCoachMark(
          targets: targets,
          colorShadow: primaryColor,
          onFinish: () {
            ref.read(sharedPrefProvider).then((pref) {
              final show2 = bool.parse(
                  pref.getString(PrefConsts.showGuide)?.split(",").last ??
                      "true");

              pref.setString(PrefConsts.showGuide, 'false,$show2');
            });
          },
          onSkip: () {
            ref.read(sharedPrefProvider).then((pref) {
              final show2 = bool.parse(
                  pref.getString(PrefConsts.showGuide)?.split(",").last ??
                      "true");

              pref.setString(PrefConsts.showGuide, 'false,$show2');
            });
            return true;
          }).show(context: context);
    }
  }

  void _handleTabChange() {
    ref
        .read(menuIndexProvider.notifier)
        .update((state) => _tabController.index);
  }

  void startSearchTimer(String searchQuery) {
    // Cancel any previous timer if it exists
    searchTimer?.cancel();

    // Start a new timer
    searchTimer = Timer(const Duration(seconds: 2), () {
      ref.read(mainNotifierProvider.notifier).searchCourses(searchQuery, 20);
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange); // remove listener first
    _tabController.dispose(); // dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(menuIndexProvider);
    if (currentIndex != _tabController.index) {
      _tabController.animateTo(currentIndex);
    }
    final audioPlayer = PlaylistHelper.audioPlayer;
    final curriculumState = ref.watch(assignedCoursesNotifierProvider);
    return WillPopScope(
      onWillPop: () async {
        if (_tabController.index != 0) {
          ref.read(menuIndexProvider.notifier).update((state) => 0);
          return false;
        } else if (i == 0) {
          i++;
          Future.delayed(const Duration(seconds: 5)).then((v) {
            i = 0;
          });
          toast("እባክዎ ድጋሚ ይንኩት!", ToastType.normal, context);
          return false;
        } else {
          if (wantToRate == null) {
            final res = await showDialog<bool>(
              context: context,
              builder: (context) => const RateUsDailog(),
            );
            if (res == null) {
              wantToRate = false;
              return false;
            }
            return res;
          }
          return true;
        }
      },
      child: StreamBuilder(
          stream: myAudioStream(audioPlayer),
          builder: (context, snap) {
            final state = snap.data?.sequenceState;
            final process = snap.data?.processingState;

            if (state?.sequence.isEmpty ?? true) {
              showTopAudio = false;
            }

            MediaItem? metaData = state?.currentSource?.tag;

            if (metaData != null) {
              showTopAudio = true;
            }

            if (process == ProcessingState.idle) {
              showTopAudio = false;
            }
            return UpdateChecker(
              child: Scaffold(
                bottomNavigationBar: BottomNav(_tabController),
                appBar: AppBar(
                  title: currentIndex != 1
                      ? curriculumState.curriculum != null && currentIndex == 0
                          ? Text(curriculumState.curriculum?.title ?? "")
                          : Text("ዒልም ፈላጊ")
                      : AnimatedSearchBar(
                          height: 50,
                          label: "ዒልም ፈላጊ",
                          controller: _searchController,
                          labelStyle: const TextStyle(fontSize: 16),
                          searchStyle: TextStyle(
                            color: ref.read(themeProvider) == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          cursorColor: primaryColor,
                          searchIcon: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(
                              key: _searchIconKey,
                              Icons.search_rounded,
                            ),
                          ),
                          textInputAction: TextInputAction.search,
                          searchDecoration: const InputDecoration(
                            hintText: 'ፈልግ...',
                            alignLabelWithHint: true,
                            fillColor: Colors.white,
                            focusColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Colors.white70,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            ref
                                .read(queryProvider.notifier)
                                .update((state) => value);
                            if (ref.watch(menuIndexProvider) != 0) {
                              ref
                                  .read(menuIndexProvider.notifier)
                                  .update((state) => 0);
                              // tabController.animateTo(0);
                            }

                            startSearchTimer(value);
                          },
                          onFieldSubmitted: (value) {
                            ref
                                .read(mainNotifierProvider.notifier)
                                .searchCourses(value, 20);
                          },
                          onClose: () {
                            ref.read(mainNotifierProvider.notifier).getCourses(
                                  context: context,
                                );
                          },
                        ),
                  bottom: PreferredSize(
                    preferredSize: Size(
                      MediaQuery.of(context).size.width,
                      showTopAudio ? 40 : 0,
                    ),
                    child: showTopAudio
                        ? CurrentAudioView(metaData as MediaItem)
                        : const SizedBox(),
                  ),
                  actions: [
                    currentIndex != 1
                        ? SizedBox()
                        : IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Fav(),
                                ),
                              );
                            },
                            icon: Icon(Icons.bookmark_rounded),
                          ),
                  ],
                  leading: Builder(builder: (context) {
                    return IconButton(
                      key: _menuKey,
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  }),
                ),
                drawer: const MainDrawer(),
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    const CurriculumTab(),
                    const Home(),
                    const AccountTab(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
