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

class _MainPageState extends ConsumerState<MainPage> {
  List<Widget> tabs = [
    const Home(),
    const Download(),
    const Fav(),
  ];

  final TextEditingController _searchController = TextEditingController();

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
            hintText: 'Search',
            alignLabelWithHint: true,
            fillColor: Colors.white,
            focusColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            debugPrint('value on Change');
            setState(() {
              // searchText = value;
            });
          },
          onFieldSubmitted: (value) {
            debugPrint('value on Field Submitted');
            setState(() {
              // searchText = value;
            });
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
      bottomNavigationBar: const BottomNav(),
      body: Consumer(builder: (context, ref, _) {
        final index = ref.watch(menuIndexProvider);
        return tabs[index];
      }),
    );
  }
}
