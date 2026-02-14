// ignore_for_file: must_call_super
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("የተመረጡ"),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Builder(
              builder: (context) {
                final state = ref.watch(favNotifierProvider);
                if (state.isLoading) {
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => const CourseShimmer(),
                  );
                } else if (!state.isLoading && state.courses.isNotEmpty) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(favNotifierProvider.notifier).getCourse();
                    },
                    color: primaryColor,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: state.courses.length,
                      itemBuilder: (context, index) {
                        return CourseItem(
                          state.courses[index],
                          keey: null,
                          val: null,
                        );
                      },
                    ),
                  );
                } else if (!state.isLoading && state.courses.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("ምንም የለም"),
                      IconButton(
                        onPressed: () async {
                          await ref.read(favNotifierProvider.notifier).getCourse();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                      )
                    ],
                  );
                } else if (!state.isLoading && state.error != null) {
                  return Center(
                    child: Text(state.error!),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
