// ignore_for_file: must_call_super

// class _DownloadState extends ConsumerState<Download>
//     with AutomaticKeepAliveClientMixin<Download> {
//   @override
//   Widget build(BuildContext context) {
// return Container(
//   child: Text("Downloads"),
// );
//   }

// @override
// bool get wantKeepAlive => true;
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants.dart';
import '../state/provider.dart';
import '../state/started_list_notifier.dart';
import '../widgets/course_item.dart';
import '../widgets/course_shimmer.dart';

class Started extends ConsumerStatefulWidget {
  const Started({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartedState();
}

class _StartedState extends ConsumerState<Started>
    with AutomaticKeepAliveClientMixin<Started> {
  late StartedListNotifier startedListNotifier;

  int countIteration = 0;

  @override
  initState() {
    super.initState();
    startedListNotifier = ref.read(startedNotifierProvider.notifier);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      startedListNotifier.getCouses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ref.watch(startedNotifierProvider).map(
            initial: (_) => const SizedBox(),
            loading: (_) => ListView.builder(
              itemCount: 10,
              itemBuilder: (index, context) => const CourseShimmer(),
            ),
            loaded: (_) => RefreshIndicator(
              onRefresh: () async {
                await ref.read(startedNotifierProvider.notifier).getCouses();
              },
              color: primaryColor,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: _.courses.length,
                itemBuilder: (context, index) {
                  return CourseItem(
                    _.courses[index],
                    fromHome: false,
                    keey: null,
                    val: null,
                  );
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
                    await ref
                        .read(startedNotifierProvider.notifier)
                        .getCouses();
                  },
                  icon: const Icon(Icons.refresh_rounded),
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
