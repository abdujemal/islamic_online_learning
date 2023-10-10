import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/widgets/list_title.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/download.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/fav.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/home.dart';
import 'package:islamic_online_learning/features/main/presentation/state/category_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/bottom_nav.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/course_item.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/course_shimmer.dart';
import 'package:islamic_online_learning/features/main/presentation/state/main_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/the_end.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ደርስ አፕ"),
       
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
