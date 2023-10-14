import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/download.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/fav.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/home.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/bottom_nav.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

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
  }

  void _handleTabChange() {
    ref.read(menuIndexProvider.notifier).update((state) => tabController.index);
  }

  @override
  Widget build(BuildContext context) {
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
              color: Colors.black45,
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.share_rounded,
            ),
          )
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
