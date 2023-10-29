import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class BottomNav extends ConsumerStatefulWidget {
  final TabController tabController;
  const BottomNav(this.tabController, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  List<IconData> icons = [
    Icons.menu_book,
    Icons.bookmark,
    Icons.play_circle,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(menuIndexProvider);
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            offset: const Offset(0, -6),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          icons.length,
          (index) => InkWell(
            onTap: () {
              widget.tabController.animateTo(index);
              ref.read(menuIndexProvider.notifier).update((state) => index);
            },
            child: Ink(
              child: Icon(
                icons[index],
                color: index == currentIndex ? primaryColor : Colors.grey,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
