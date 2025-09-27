// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_call_super

import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/playlist_helper.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/contents.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/download_database.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:islamic_online_learning/features/main/presentation/pages/ustazs.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/beginner_courses_list.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/main_category.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/started_course_list.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/constants.dart';
import '../../../courseDetail/presentation/pages/course_detail.dart';
import '../state/category_list_notifier.dart';
import '../state/main_list_notifier.dart';
import '../state/provider.dart';
import '../widgets/course_item.dart';
import '../widgets/course_shimmer.dart';
import '../widgets/the_end.dart';

class Home extends ConsumerStatefulWidget {
  const Home({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with AutomaticKeepAliveClientMixin<Home> {
  late CategoryListNotifier categoryNotifier;
  late MainListNotifier mainNotifier;
  // late StartedListNotifier startedListNotifier;

  ScrollController scrollController = ScrollController();

  int countIteration = 0;

  bool isSearching = false;

  bool showFloatingBtn = false;

  final AppLinks _appLinks = AppLinks();

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

  @override
  void initState() {
    super.initState();

    categoryNotifier = ref.read(categoryNotifierProvider.notifier);
    mainNotifier = ref.read(mainNotifierProvider.notifier);
    // startedListNotifier = ref.read(startedNotifierProvider.notifier);

    scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mainNotifier
          .getCourses(
        isNew: true,
        context: context,
      )
          .then((value) {
        categoryNotifier.getCategories();
      });
      ref.read(beginnerListProvider.notifier).getCourses();
      ref.watch(startedNotifierProvider.notifier).getCouses();

      // Listen to new incoming links
      _appLinks.uriLinkStream.listen(_handleDeepLink);
    });

    // tabController = TabController(length: 3, vsync: this);

    FirebaseMessaging.instance.subscribeToTopic("v1.0.1");

    // tabController.addListener(_handleTabChange);

    if (FirebaseAuth.instance.currentUser == null) {
      FirebaseAuth.instance.signInAnonymously().then((value) {
        toast("እንኳን ደህና መጡ!", ToastType.success, context);
      });
    }

    if (mounted) {
      ref.read(mainNotifierProvider.notifier).getTheme();
      ref.read(sharedPrefProvider).then((pref) {
        wantToRate = pref.getBool("wantToRate");
        ref.read(fontScaleProvider.notifier).update(
              (state) => pref.getDouble("fontScale") ?? 1.0,
            );
      });

      ref.read(sharedPrefProvider).then((pref) {
        ref.read(showGuideProvider.notifier).update(
          (state) {
            show = bool.parse(
                pref.getString("showGuide")?.split(",").first ?? "true");
            return [
              show,
              bool.parse(pref.getString("showGuide")?.split(",").last ?? "true")
            ];
          },
        );
      });

      ref.read(sharedPrefProvider).then((pref) {
        bool isSubed = pref.getBool("isSubed") ?? true;
        if (isSubed) {
          FirebaseMessaging.instance.subscribeToTopic("ders");
        }
      });

      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   ref.watch(menuIndexProvider.notifier).addListener(
      //     (state) {
      //       tabController.animateTo(state);
      //     },
      //   );
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
                  pref.getString("showGuide")?.split(",").last ?? "true");

              pref.setString("showGuide", 'false,$show2');
            });
          },
          onSkip: () {
            ref.read(sharedPrefProvider).then((pref) {
              final show2 = bool.parse(
                  pref.getString("showGuide")?.split(",").last ?? "true");

              pref.setString("showGuide", 'false,$show2');
            });
            return true;
          }).show(context: context);
    }
  }

  // void _handleTabChange() {
  //   ref.read(menuIndexProvider.notifier).update((state) => tabController.index);
  // }

  void startSearchTimer(String searchQuery) {
    // Cancel any previous timer if it exists
    searchTimer?.cancel();

    // Start a new timer
    searchTimer = Timer(const Duration(seconds: 2), () {
      ref.read(mainNotifierProvider.notifier).searchCourses(searchQuery, 20);
    });
  }

  @override
  bool get wantKeepAlive => true;

  // @override
  // initState() {
  //   super.initState();
  // categoryNotifier = ref.read(categoryNotifierProvider.notifier);
  // mainNotifier = ref.read(mainNotifierProvider.notifier);
  // // startedListNotifier = ref.read(startedNotifierProvider.notifier);

  // scrollController.addListener(_scrollListener);

  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //   mainNotifier
  //       .getCourses(
  //     isNew: true,
  //     context: context,
  //   )
  //       .then((value) {
  //     categoryNotifier.getCategories();
  //   });
  //   ref.read(beginnerListProvider.notifier).getCourses();
  //   ref.watch(startedNotifierProvider.notifier).getCouses();

  //   // Listen to new incoming links
  //   _appLinks.uriLinkStream.listen(_handleDeepLink);

  // FirebaseDynamicLinks.instance.getInitialLink().then((value) {
  //   print("link:- ${value?.link}");
  //   print("Segments: ${value?.link.pathSegments}");
  //   if (value?.link.pathSegments.contains("courses") ?? false) {
  //     String id = Uri.decodeFull(value?.link.toString() ?? "")
  //         .split("/")
  //         .last
  //         .replaceAll("courses?id=", "")
  //         .replaceAll("+", " ");
  //     print("id: $id");
  //     // String? id = widget.initialLink!.link.queryParameters["id"];

  //     getCourseAndRedirect(id);
  //   }
  // });
  // });

  //   linkStream.listen((event) {
  //     if (event != null) {
  //       Uri link = Uri.parse(event);
  //       print("link:- ${link.toString()}");
  //       print("Segments: ${link.pathSegments}");
  //       if (link.pathSegments.contains("courses")) {
  //         String id = Uri.decodeFull(link.toString())
  //             .split("/")
  //             .last
  //             .replaceAll("courses?id=", "")
  //             .replaceAll("+", " ");
  //         print("id: $id");

  //         getCourseAndRedirect(id);
  //       }
  //     }
  //   }).onError((e) {
  //     toast(
  //       e.toString(),
  //       ToastType.error,
  //       context,
  //       isLong: true,
  //     );
  //   });
  // }

  void _handleDeepLink(Uri? uri) {
    if (uri == null) return;

    if (kDebugMode) {
      print("Opening: ${uri.pathSegments}");
    }

    final courseId = uri.pathSegments.last;

    getCourseAndRedirect(courseId);
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
            builder: (_) => CourseDetail(
              cm: res,
              keey: null,
              val: null,
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        toast("ስህተት ተፈጥሯል።", ToastType.error, context);
      }
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollListener() async {
    if (scrollController.offset > 400) {
      bool rebuild = false;
      if (showFloatingBtn == false) {
        rebuild = true;
      }
      showFloatingBtn = true;

      if (rebuild) {
        setState(() {});
      }
    } else {
      bool rebuild = false;
      if (showFloatingBtn == true) {
        rebuild = true;
      }
      showFloatingBtn = false;

      if (rebuild) {
        setState(() {});
      }
    }
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isSearching) {
        await mainNotifier.getCourses(
          context: context,
          isNew: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    isSearching = ref.watch(queryProvider) == "";
    final audioPlayer = PlaylistHelper.audioPlayer;
    return StreamBuilder(
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

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: ref.watch(mainNotifierProvider).map(
                      // initial: (_) => const SizedBox(),
                      loading: (_) => ListView.builder(
                        itemCount: isSearching ? 10 + 1 : 10,
                        itemBuilder: (context, index) {
                          if (index == 0 && isSearching) {
                            return Wrap(
                              // height: 50,
                              children: List.generate(
                                // itemCount: 5,
                                // scrollDirection: Axis.horizontal,
                                4,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: index == 0
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (ctx) =>
                                                    const Ustazs(),
                                              ),
                                            );
                                          },
                                          child: Chip(
                                            avatar: Image.asset(
                                                'assets/teacher.png'),
                                            backgroundColor: primaryColor,
                                            labelPadding:
                                                const EdgeInsets.all(0),
                                            side: BorderSide.none,
                                            label: const Text(
                                              "ኡስታዞች",
                                              style: TextStyle(
                                                color: whiteColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      : index == 1
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        const Contents(),
                                                  ),
                                                );
                                              },
                                              child: const Chip(
                                                avatar: Icon(
                                                  Icons.content_paste_outlined,
                                                  color: whiteColor,
                                                ),
                                                backgroundColor: primaryColor,
                                                labelPadding: EdgeInsets.all(0),
                                                side: BorderSide.none,
                                                label: Text(
                                                  "ማውጫ",
                                                  style: TextStyle(
                                                    color: whiteColor,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Shimmer.fromColors(
                                              baseColor: Theme.of(context)
                                                  .chipTheme
                                                  .backgroundColor!
                                                  .withAlpha(150),
                                              highlightColor: Theme.of(context)
                                                  .chipTheme
                                                  .backgroundColor!,
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (index == 0) {}
                                                },
                                                child: const Chip(
                                                  labelPadding:
                                                      EdgeInsets.all(0),
                                                  side: BorderSide.none,
                                                  label: Text(
                                                    "_______",
                                                    style: TextStyle(
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                ),
                              ),
                            );
                          }
                          return const CourseShimmer();
                        },
                      ),
                      loaded: (_) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            if (isSearching) {
                              await mainNotifier.getCourses(
                                isNew: true,
                                context: context,
                              );
                              await categoryNotifier.getCategories();
                              await ref
                                  .read(beginnerListProvider.notifier)
                                  .getCourses();
                              await ref
                                  .watch(startedNotifierProvider.notifier)
                                  .getCouses();
                            }
                          },
                          color: primaryColor,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            controller: scrollController,
                            itemCount:
                                // isSearching
                                /*?*/ _.courses.length + 4,
                            // : _.courses.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return !isSearching
                                    ? const SizedBox()
                                    : const MainCategories();
                              } else if (index == 1) {
                                return !isSearching
                                    ? const SizedBox()
                                    : const StartedCourseList();
                              } else if (index == 5) {
                                return !isSearching
                                    ? const SizedBox()
                                    : const BeginnerCoursesList();
                              } else if (isSearching &&
                                      index <= _.courses.length + 2 ||
                                  !isSearching &&
                                      index <= _.courses.length + 1) {
                                return CourseItem(
                                  _.courses[index < 5 ? index - 2 : index - 3],
                                  index: index < 5 ? index - 2 : index - 3,
                                  courseCategory: _courseCategoryKey,
                                  courseTitle: _courseTitleKey,
                                  courseUstaz: _courseUstazKey,
                                  keey: null,
                                  val: null,
                                );
                              } else if (_.noMoreToLoad) {
                                return const TheEnd();
                              } else {
                                if (!isSearching) {
                                  return const SizedBox();
                                }
                                return const CourseShimmer();
                              }
                            },
                          ),
                        );
                      },
                      empty: (_) => Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("ምንም የለም"),
                            IconButton(
                              onPressed: () async {
                                await mainNotifier.getCourses(
                                  isNew: true,
                                  context: context,
                                );
                                await categoryNotifier.getCategories();
                              },
                              icon: const Icon(Icons.refresh_rounded),
                            )
                          ],
                        ),
                      ),
                      error: (_) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_.error ?? ""),
                            ElevatedButton(
                              onPressed: () async {
                                Directory directory =
                                    await getApplicationSupportDirectory();
                                String path = '${directory.path}$dbPath';
                                await File(path).delete();
                                if (mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const DownloadDatabase()),
                                      (n) => false);
                                }
                              },
                              child: const Text("ደጋሚ ይሞክሩት"),
                            )
                          ],
                        ),
                      ),
                    ),
              ),
              AnimatedPositioned(
                right: 5,
                bottom: showFloatingBtn ? 5 : -57,
                duration: const Duration(milliseconds: 500),
                child: Opacity(
                  opacity: /*showFloatingBtn ?*/ 1.0 /*: 0.0*/,
                  child: FloatingActionButton(
                    onPressed: () => scrollController
                        .animateTo(
                          0.0, // Scroll to the top
                          curve: Curves.easeOut,
                          duration: const Duration(milliseconds: 500),
                        )
                        .then((value) => setState(() {})),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
