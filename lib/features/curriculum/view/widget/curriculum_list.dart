import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/curriculum_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/curriculum_shimmer.dart';

class CurriculumList extends ConsumerStatefulWidget {
  const CurriculumList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurriculumListState();
}

class _CurriculumListState extends ConsumerState<CurriculumList> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(curriculumNotifierProvider);
    if (state.initial) {
      return SizedBox();
    }
    return Expanded(
      child: Column(
        children: [
          Text(
            "ክፍሎች",
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: ref.watch(curriculumNotifierProvider).map(
                  loading: (_) => ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => CurriculumShimmer(),
                  ),
                  loaded: (_) => RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(curriculumNotifierProvider.notifier)
                          .getCurriculums();
                    },
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: _.curriculums.length,
                      itemBuilder: (context, i) {
                        return CurriculumCard(curriculum: _.curriculums[i]);
                      },
                    ),
                  ),
                  empty: (_) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ክፍሎች ማግኘት አልተቻለም።"),
                        IconButton(
                          onPressed: () async {
                            await ref
                                .read(curriculumNotifierProvider.notifier)
                                .getCurriculums();
                          },
                          icon: Icon(Icons.refresh),
                        )
                      ],
                    ),
                  ),
                  error: (_) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _.error ?? "",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await ref
                                .read(curriculumNotifierProvider.notifier)
                                .getCurriculums();
                          },
                          icon: Icon(Icons.refresh),
                        )
                      ],
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
