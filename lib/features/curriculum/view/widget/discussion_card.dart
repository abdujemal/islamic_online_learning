import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/static_datas.dart';
import 'package:islamic_online_learning/features/auth/model/const_score.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/exam_card.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/template/view/pages/voice_room.dart';

class DiscussionCard extends ConsumerStatefulWidget {
  final bool isLocked;
  final bool isCurrent;
  final bool isExamLocked;
  final bool isExamCurrent;
  final bool isLastDiscussion;
  final bool hasExam;
  final ExamData? examData;
  final DiscussionData discussionData;
  const DiscussionCard({
    super.key,
    required this.isExamCurrent,
    required this.isExamLocked,
    required this.examData,
    required this.hasExam,
    required this.isLastDiscussion,
    required this.discussionData,
    required this.isLocked,
    required this.isCurrent,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscussionCardState();
}

class _DiscussionCardState extends ConsumerState<DiscussionCard> {
  final GlobalKey _key = GlobalKey();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final box = _key.currentContext?.findRenderObject() as RenderBox?;
  //     if (box != null) {
  //       print("Discussion card: ${box.size.height}");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final authState = ref.watch(authNotifierProvider);
    final score =
        ConstScore.get(ScoreNames.Discussion, ref, authState.scores ?? []);
    return Column(
      key: _key,
      children: [
        Container(
          // key:_key,
          margin: EdgeInsets.only(
            top: 10,
          ),
          width: double.infinity,
          color: Theme.of(context).cardColor,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 10,
                ),
                child: Stack(
                  children: [
                    Column(
                      spacing: 3,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.groups,
                              color: Colors.blue,
                              size: 40,
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 3,
                                    children: [
                                      Text(
                                        "ውይይት/ሙጣለዓ",
                                        style: TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        widget.discussionData.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3,
                                        vertical: .5,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Text(
                                        "${score?.totalScore ?? "..."} ነጥብ",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => VoiceRoomPage(
                                          title: widget.discussionData.title,
                                          afterLessonNo:
                                              widget.discussionData.lessonTo,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
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
                        bottom: 0,
                        child: Icon(Icons.lock_outline),
                      ),
                  ],
                ),
              ),
              if (widget.isLocked)
                Positioned.fill(
                  child: Container(
                    color: theme == ThemeMode.light
                        ? Colors.white60
                        : Colors.black54,
                  ),
                ),
            ],
          ),
        ),
        if (widget.hasExam)
          ExamCard(
            examData: widget.examData!,
            discussionData: widget.discussionData,
            isLastExam: widget.isLastDiscussion,
            isLocked: widget.isExamLocked,
            isCurrent: widget.isExamCurrent,
          )
      ],
    );
  }
}
