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
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/core/topic_constants.dart';
import 'package:islamic_online_learning/core/update_checker.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/auth/view/pages/account_tab.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/pages/curriculum_tab.dart';
// import 'package:islamic_online_learning/features/curriculum/view/pages/islamic_streak_page.dart';
import 'package:islamic_online_learning/features/groupChat/view/controller/provider.dart';
import 'package:islamic_online_learning/features/groupChat/view/pages/group_chat_page.dart';
// import 'package:islamic_online_learning/features/groupChat/view/pages/group_chat_page.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/fav.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/home.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/bottom_nav.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/main_drawer.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/rate_us_dailog.dart';
import 'package:islamic_online_learning/features/notifications/view/controller/provider.dart';
import 'package:islamic_online_learning/features/notifications/view/pages/notifications_page.dart';
import 'package:islamic_online_learning/features/payments/view/pages/pricing_page.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/Audio Feature/current_audio_view.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key, });
  
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

  // final List<QuestionnaireQuestion> sampleQuestions = [
  //   QuestionnaireQuestion(
  //     id: 'q_pay',
  //     text: 'Would you pay for this service?',
  //     type: QuestionType.singleChoice,
  //     required: true,
  //     options: [
  //       QuestionOption(
  //         id: 'opt_yes',
  //         label: 'Yes, I would pay',
  //         value: 'YES_PAY',
  //         // order: 1,
  //       ),
  //       QuestionOption(
  //         id: 'opt_maybe',
  //         label: 'Maybe, depends on price',
  //         value: 'MAYBE',
  //         // order: 2,
  //       ),
  //       QuestionOption(
  //         id: 'opt_no',
  //         label: 'No, I would not pay',
  //         value: 'WONT_PAY',
  //         // order: 3,
  //       ),
  //     ],
  //     triggers: [
  //       QuestionCondition(
  //         sourceQuestionId: 'q_pay',
  //         triggerValue: 'WONT_PAY',
  //         targetQuestionId: 'q_why_not',
  //       ),
  //       QuestionCondition(
  //         sourceQuestionId: 'q_pay',
  //         triggerValue: 'MAYBE',
  //         targetQuestionId: 'q_price',
  //       ),
  //     ],
  //   ),
  //   QuestionnaireQuestion(
  //     id: 'q_why_not',
  //     text: 'Why would you not pay? What should we improve to convince you?',
  //     type: QuestionType.longText,
  //     required: true,
  //   ),
  //   QuestionnaireQuestion(
  //     id: 'q_price',
  //     text: 'How much would you be willing to pay per month?',
  //     type: QuestionType.priceInput,
  //     required: true,
  //     // currency: 'USD',
  //   ),
  //   QuestionnaireQuestion(
  //     id: 'q_rating',
  //     text: 'How valuable do you think this service is?',
  //     type: QuestionType.rating,
  //     required: true,
  //   ),
  // ];

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

    _tabController.addListener(_handleTabChange);

    if (FirebaseAuth.instance.currentUser == null) {
      FirebaseAuth.instance.signInAnonymously().then((value) {
        toast("እንኳን ደህና መጡ!", ToastType.success, context);
      });
    }

    Future.microtask(() {
      if (mounted) {
        ref.read(sharedPrefProvider).then((pref) {
          bool isSubed = pref.getBool(PrefConsts.isSubed) ?? true;
          if (isSubed) {
            getAccessToken().then((token) {
              final curriculumId = pref.getString(PrefConsts.curriculumId);
              final otpId = pref.getString(PrefConsts.otpId);
              if (token != null && curriculumId != null && otpId == null) {
                FirebaseMessaging.instance.subscribeToTopic(proUserSub);
                FirebaseMessaging.instance.unsubscribeFromTopic(legacySub);
              } else {
                FirebaseMessaging.instance.subscribeToTopic(legacySub);
                FirebaseMessaging.instance.unsubscribeFromTopic(proUserSub);
              }
            });
          }
          FirebaseMessaging.instance.subscribeToTopic(versionSub);
        });

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
      }
    });

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

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
    final isDue =
        ref.watch(authNotifierProvider).user?.subscription.isDue() ?? false;
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
                        showTopAudio
                            ? isDue
                                ? 80 + 40
                                : 40
                            : isDue
                                ? 80
                                : 0,
                      ),
                      child: Column(
                        children: [
                          showTopAudio
                              ? CurrentAudioView(metaData as MediaItem)
                              : const SizedBox(),
                          isDue
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                      right: 20,
                                      left: 20,
                                      top: 15,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        border: Border.all(
                                          color: Colors.amber,
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      children: [
                                        Text("Payment is Due"),
                                        Spacer(),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PricingPage(),
                                              ),
                                            );
                                          },
                                          child: Text("Add Payment"),
                                        )
                                        // InkWell(
                                        //   onTap: () {},
                                        //   child: Ink(
                                        //     child: Text("Add Payment", col),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox()
                        ],
                      )),
                  actions: [
                    // Consumer(
                    //   builder: (context, ref, child) {
                    //     final authState = ref.watch(authNotifierProvider);
                    //     final groupChatState =
                    //         ref.watch(groupChatNotifierProvider);
                    //     final noUnreadChats = groupChatState.unreadChats;
                    //     if (authState.user != null) {
                    //       return Stack(
                    //         children: [
                    //           IconButton(
                    //             onPressed: () {
                    //               // print(authState.user);
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (_) => GroupChatPage(),
                    //                   //     QuestionnaireScreen(
                    //                   //   questions: sampleQuestions,
                    //                   // ),
                    //                 ),
                    //               );
                    //             },
                    //             icon: Icon(Icons.chat_rounded),
                    //           ),
                    //           if (noUnreadChats > 0)
                    //             Positioned(
                    //               right: 6,
                    //               bottom: 4,
                    //               child: Container(
                    //                 padding: EdgeInsets.all(4),
                    //                 decoration: BoxDecoration(
                    //                   shape: BoxShape.circle,
                    //                   color: primaryColor,
                    //                 ),
                    //                 child: Text(
                    //                   "$noUnreadChats",
                    //                   style: TextStyle(
                    //                     fontSize: 10,
                    //                     color: Colors.white,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //         ],
                    //       );
                    //     } else {
                    //       return SizedBox();
                    //     }
                    //   },
                    // ),
                    
                    currentIndex != 1
                        ? Consumer(builder: (context, ref, child) {
                            final authState = ref.watch(authNotifierProvider);
                            final notificationState =
                                ref.watch(notificationNotifierProvider);
                            final unreadNotifications =
                                notificationState.unreadNotifications;
                            if (authState.user != null) {
                              return Stack(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => NotificationsPage()

                                            // IslamicStreakPage(
                                            //   streak: 4,
                                            //   lessonsCompleted: 10,
                                            //   type: "Discussion",
                                            // ),
                                            ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.notifications_rounded,
                                    ),
                                  ),
                                  if (unreadNotifications > 0)
                                    Positioned(
                                      right: 6,
                                      bottom: 4,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: primaryColor,
                                        ),
                                        child: Text(
                                          "$unreadNotifications",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            } else {
                              return SizedBox();
                            }
                          })
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
                body: SafeArea(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      const CurriculumTab(),
                      const Home(),
                      const AccountTab(),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
