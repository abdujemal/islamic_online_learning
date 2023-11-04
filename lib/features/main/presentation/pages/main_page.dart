import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/download.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/fav.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/home.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/bottom_nav.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/main_drawer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late TabController tabController;

  int i = 0;

  final GlobalKey _searchIconKey = GlobalKey();
  final GlobalKey _ustazsKey = GlobalKey();

  final GlobalKey _menuKey = GlobalKey();
  // final GlobalKey _courseNameKey = GlobalKey();
  // final GlobalKey _courseUstaz = GlobalKey();
  // final GlobalKey _courseCategory = GlobalKey();
  // final GlobalKey _bookmarkey = GlobalKey();

  bool show = false;

  bool showOnes = true;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);

    tabController.addListener(_handleTabChange);

    if (mounted) {
      ref.read(mainNotifierProvider.notifier).getTheme();
      ref.read(sharedPrefProvider).then((pref) {
        ref.read(fontScaleProvider.notifier).update(
              (state) => pref.getDouble("fontScale") ?? 1.0,
            );
      });

      ref.read(sharedPrefProvider).then((pref) {
        ref.read(showGuideProvider.notifier).update(
          (state) {
            show = pref.getBool("showGuide") ?? true;
            return show;
          },
        );
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        final mainState = ref.read(mainNotifierProvider.notifier);

        mainState.addListener((state) {
          state.mapOrNull(loaded: (_) {
            if (mounted) {
              bool isOnCurrentPage = !Navigator.canPop(context);
              if (isOnCurrentPage) {
                if (showOnes) {
                  showTutorial();
                  showOnes = false;
                }
              }
            }
          });
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
        key: _ustazsKey,
        identify: "UstazsButton",
        align: ContentAlign.right,
        title: "የኡስታዞች ቁልፍ",
        subtitle: "ይህንን ቁልፍ ነክተው ኡስታዞችን ዝርዝር ማግኘት ይችላሉ።",
      ),
    ];

    if (show) {
      TutorialCoachMark(
          targets: targets,
          colorShadow: primaryColor,
          onSkip: () {
            ref.read(sharedPrefProvider).then((pref) {
              pref.setBool("showGuide", false);
            });
            return true;
          }).show(context: context);
    }
  }

  void _handleTabChange() {
    ref.read(menuIndexProvider.notifier).update((state) => tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    final currentAudio = ref.watch(currentAudioProvider);
    return WillPopScope(
      onWillPop: () async {
        if (i == 0) {
          i++;
          Future.delayed(const Duration(seconds: 5)).then((v) {
            i = 0;
          });
          toast("እባክዎ ድጋሚ ይንኩት!", ToastType.normal);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSearchBar(
            height: 50,
            label: "ደርስ አፕ",
            controller: _searchController,
            labelStyle: const TextStyle(fontSize: 16),
            searchStyle: const TextStyle(color: Colors.black),
            cursorColor: const Color.fromRGBO(0, 0, 0, 1),
            searchIcon: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Icon(
                key: _searchIconKey,
                Icons.search,
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
              ref.read(queryProvider.notifier).update((state) => value);
              if (ref.watch(menuIndexProvider) != 0) {
                ref.read(menuIndexProvider.notifier).update((state) => 0);
                tabController.animateTo(0);
              }
              ref.read(mainNotifierProvider.notifier).searchCourses(value, 20);
            },
            onFieldSubmitted: (value) {
              ref.read(mainNotifierProvider.notifier).searchCourses(value, 20);
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size(
              MediaQuery.of(context).size.width,
              currentAudio != null ? 40 : 0,
            ),
            child: currentAudio != null
                ? CurrentAudioView(currentAudio)
                : const SizedBox(),
          ),
          leading: Builder(builder: (context) {
            return IconButton(
              key: _menuKey,
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        drawer: const MainDrawer(),
        bottomNavigationBar: BottomNav(tabController),
        body: TabBarView(
          controller: tabController,
          children: [
            Home(
              ustazKey: _ustazsKey,
            ),
            const Fav(),
            const Download(),
          ],
        ),
      ),
    );
  }
}
