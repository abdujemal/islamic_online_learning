import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class DiscussionCard extends ConsumerStatefulWidget {
  final bool isLocked;
  final bool isCurrent;
  final DiscussionData discussionData;
  const DiscussionCard({
    super.key,
    required this.discussionData,
    required this.isLocked,
    required this.isCurrent,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends ConsumerState<DiscussionCard> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 15,
          ),
          width: double.infinity,
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Stack(
              children: [
                Column(
                  spacing: 6,
                  children: [
                    Row(
                      spacing: 18,
                      children: [
                        Icon(
                          Icons.groups,
                          color: Colors.purple,
                          size: 40,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 6,
                            children: [
                              Text(
                                "ውይይት/ሙጣለዓ",
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                widget.discussionData.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 3,
                                  vertical: .5,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  "30 ነጥብ",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: widget.isCurrent
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.circular(12),
                                    ),
                              ),
                              child: const Text(
                                "ውይይቱን ጀምር",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: whiteColor,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
                if (widget.isLocked)
                  Positioned(
                    right: 0,
                    child: Icon(Icons.lock_outline),
                  ),
              ],
            ),
          ),
        ),
        if (widget.isLocked)
          Positioned.fill(
            child: Container(
              color: theme == ThemeMode.light ? Colors.white60 : Colors.black54,
            ),
          ),
      ],
    );
  }
}
