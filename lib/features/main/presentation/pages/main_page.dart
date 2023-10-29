import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/pages/downloaded_files_page.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/download.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/fav.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/home.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/bottom_nav.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with TickerProviderStateMixin {
  List<Widget> tabs = [
    const Home(),
    const Fav(),
    const Download(),
  ];

  final TextEditingController _searchController = TextEditingController();

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 3, vsync: this);

    tabController.addListener(_handleTabChange);

    if (mounted) {
      ref.read(mainNotifierProvider.notifier).getTheme();
    }
  }

  void _handleTabChange() {
    ref.read(menuIndexProvider.notifier).update((state) => tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    final currentAudio = ref.watch(currentAudioProvider);
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSearchBar(
          height: 50,
          label: "ደርስ አፕ",
          controller: _searchController,
          labelStyle: const TextStyle(fontSize: 16),
          searchStyle: const TextStyle(color: Colors.black),
          cursorColor: Colors.black,
          searchIcon: const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Icon(
              Icons.search,
              color: primaryColor,
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
            currentAudio != null ? 60 : 0,
          ),
          child: currentAudio != null
              ? CurrentAudioView(currentAudio)
              : const SizedBox(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DownloadedFilesPage(),
                ),
              );
            },
            icon: const Icon(Icons.download),
          ),
          Consumer(builder: (context, ref, _) {
            final theme = ref.watch(themeProvider);
            return IconButton(
              onPressed: () {
                ref.read(mainNotifierProvider.notifier).changeTheme(
                    theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
              },
              icon: Icon(
                theme == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
              ),
            );
          })
        ],
      ),
      bottomNavigationBar: BottomNav(tabController),
      body: TabBarView(
        controller: tabController,
        children: tabs,
      ),
    );
  }
}
