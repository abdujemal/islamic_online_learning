import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/static_datas.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class ExamCard extends ConsumerStatefulWidget {
  final bool isLastExam;
  final bool isLocked;
  final bool isCurrent;
  final ExamData examData;
  final DiscussionData discussionData;
  const ExamCard({
    super.key,
    required this.examData,
    required this.discussionData,
    required this.isLocked,
    required this.isCurrent,
    required this.isLastExam,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExamCardState();
}

class _ExamCardState extends ConsumerState<ExamCard> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final authState = ref.watch(authNotifierProvider);
    final score =
        Score.get(ScoreNames.IndividualAssignment, ref, authState.scores ?? []);

    return Container(
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
                          Icons.question_mark_rounded,
                          color: Colors.purple,
                          size: 40,
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 3,
                                children: [
                                  Text(
                                    "ፈተና",
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    widget.isLastExam
                                        ? "ሙሉ ኪታቡን"
                                        : widget.examData.title,
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
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.circular(12),
                                    ),
                              ),
                              child: const Text(
                                "ፈተናውን ጀምር",
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
                color:
                    theme == ThemeMode.light ? Colors.white60 : Colors.black54,
              ),
            ),
        ],
      ),
    );
  }
}
