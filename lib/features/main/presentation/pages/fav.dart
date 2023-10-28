// ignore_for_file: must_call_super

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/presentation/state/fav_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

import '../widgets/course_item.dart';
import '../widgets/course_shimmer.dart';

class Fav extends ConsumerStatefulWidget {
  const Fav({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavState();
}

class _FavState extends ConsumerState<Fav>
    with AutomaticKeepAliveClientMixin<Fav> {
  late FavListNotifier favListNotifier;

  int countIteration = 0;

  @override
  initState() {
    super.initState();
    favListNotifier = ref.read(favNotifierProvider.notifier);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      favListNotifier.getCourse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ref.watch(favNotifierProvider).map(
            initial: (_) => const SizedBox(),
            loading: (_) => ListView.builder(
              itemCount: 10,
              itemBuilder: (index, context) => const CourseShimmer(),
            ),
            loaded: (_) => RefreshIndicator(
              onRefresh: () async {
                await ref.read(favNotifierProvider.notifier).getCourse();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 0),
                itemCount: _.courses.length,
                itemBuilder: (context, index) {
                  return CourseItem(_.courses[index]);
                },
              ),
            ),
            empty: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("ምንም የለም"),
                IconButton(
                  onPressed: () async {
                    await ref.read(favNotifierProvider.notifier).getCourse();
                  },
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
            error: (_) => Center(
              child: Text(_.error.messege),
            ),
          ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
