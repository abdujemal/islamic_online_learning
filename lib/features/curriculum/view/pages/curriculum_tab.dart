import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/lib/api_handler.dart';
import 'package:islamic_online_learning/core/lib/pref_consts.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/assigned_course_list.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/curriculum_list.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/group_members_status.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class CurriculumTab extends ConsumerStatefulWidget {
  const CurriculumTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CurriculumTabState();
}

class _CurriculumTabState extends ConsumerState<CurriculumTab>
    with AutomaticKeepAliveClientMixin<CurriculumTab> {
  String? token, curriculumId;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(sharedPrefProvider).then((pref) async {
        token = await getAccessToken();
        curriculumId = pref.getString(PrefConsts.curriculumId);
        final otpId = pref.getString(PrefConsts.otpId);

        if (token != null && curriculumId != null && otpId == null) {
          ref.read(authNotifierProvider.notifier).getMyInfo(ref);
        } else if (otpId != null) {
          ref.read(authNotifierProvider.notifier).unfinishedRegistration(
                otpId,
                context,
                // signedIn: token != null,
              );
        } else {
          ref.read(curriculumNotifierProvider.notifier).getCurriculums();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    // final curriculumState = ref.watch(curriculumNotifierProvider);

    super.build(context);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (authState.tokenIsNull && !authState.isLoading) CurriculumList(),
          if (!authState.initial && !authState.courseStarted)
            GroupMembersStatus(),
          if (authState.user != null &&
              authState.courseStarted &&
              authState.error == null)
            AssignedCourseList()
        ],
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
