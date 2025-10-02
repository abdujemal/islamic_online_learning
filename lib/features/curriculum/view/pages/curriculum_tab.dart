import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/features/auth/view/pages/register_page.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/curriculum_provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/curriculum_card.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/curriculum_shimmer.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class CurriculumTab extends ConsumerStatefulWidget {
  const CurriculumTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurriculumTabState();
}

class _CurriculumTabState extends ConsumerState<CurriculumTab> with AutomaticKeepAliveClientMixin<CurriculumTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(curriculumNotifierProvider.notifier).getCurriculums();
      ref.read(sharedPrefProvider).then((pref) {
        final otpId = pref.getString(PrefConsts.otpId);
        if (otpId != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => RegisterPage(
                otpId: otpId,
              ),
            ),
            (v) => false,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ክፍሎች",
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: ref.watch(curriculumNotifierProvider).map(
                  loading: (_) => RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(curriculumNotifierProvider.notifier)
                          .getCurriculums();
                    },
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => CurriculumShimmer(),
                    ),
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
    ));
  }
  
  @override
  bool get wantKeepAlive => true;
}
