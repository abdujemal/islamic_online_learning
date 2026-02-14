import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/lesson_shimmer.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/user_with_group_display.dart';

class GroupMembersStatus extends ConsumerStatefulWidget {
  const GroupMembersStatus({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupMembersStatusState();
}

class _GroupMembersStatusState extends ConsumerState<GroupMembersStatus> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ref.watch(authNotifierProvider).map(
            loading: (_) => ListView(
              children: [
                Column(
                  children: List.generate(
                    10,
                    (index) => LessonShimmer(),
                  ),
                ),
              ],
            ),
            loaded: (_) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [UserWithGroupDisplay(user: _.user!)],
              ),
            ),
            error: (_) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _.error ?? "",
                    style: TextStyle(color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(authNotifierProvider.notifier)
                          .getMyInfo(context);
                    },
                    icon: Icon(Icons.refresh),
                  )
                ],
              ),
            ),
          ),
    );
  }
}
