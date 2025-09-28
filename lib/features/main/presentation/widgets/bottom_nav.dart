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
  List<String> icons = [
    "assets/grad.png",
    "assets/book.png",
    "assets/account.png",
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(menuIndexProvider);
    return SafeArea(
      child: Container(
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
                if (index == 2) {
                  toast("ይቅርታ አካውንት የሎትም!", ToastType.error, context);
                  return;
                }
                widget.tabController.animateTo(index);
                ref.read(menuIndexProvider.notifier).update((state) => index);
              },
              child: Ink(
                child: Image.asset(
                  icons[index],
                  color: index == currentIndex ? primaryColor : Colors.grey,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
