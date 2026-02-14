import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/static_datas.dart';
// import 'package:islamic_online_learning/core/widgets/bouncy_button.dart';
import 'package:islamic_online_learning/features/auth/model/const_score.dart';
import 'package:islamic_online_learning/features/auth/model/score.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/AssignedCourseController/assigned_courses_notifier.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
// import 'package:islamic_online_learning/features/quiz/model/test_attempt.dart';
// import 'package:islamic_online_learning/features/quiz/view/pages/question_page.dart';

class ExamCard extends ConsumerStatefulWidget {
  final bool isLastExam;
  final bool isLocked;
  final bool isCurrent;
  final int afterLesson;
  final ExamData examData;
  final DiscussionData discussionData;
  const ExamCard({
    super.key,
    required this.examData,
    required this.discussionData,
    required this.isLocked,
    required this.isCurrent,
    required this.isLastExam,
    required this.afterLesson,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExamCardState();
}

class _ExamCardState extends ConsumerState<ExamCard> {
  ConstScore? constScore;
  Score? getScore() {
    final isPastLesson = !widget.isCurrent && !widget.isLocked;
    // final testResult = ref
    //     .watch(assignedCoursesNotifierProvider)
    //     .testAttempts
    //     .where(
    //       (e) => e.afterLessonNum == widget.examData.lessonTo,
    //     )
    //     .toList();
    // // print(
    // //     "testResult: $testResult, $isPastLesson ${widget.examData.lessonFrom}");
    // TestAttempt? testAttempt = testResult.isNotEmpty ? testResult.first : null;

    // if (testAttempt == null) {
      // if (isPastLesson) {
      //   final score = Score(
      //     id: "id",
      //     targetType: "IndividualAssignment",
      //     targetId: "testAttempt.id",
      //     score: 0,
      //     afterLesson: widget.afterLesson,
      //     gradeWaiting: false,
      //     outOf: constScore?.totalScore ?? 0,
      //     userId: "userId",
      //     date: DateTime.now(),
      //   );
      //   return score;
      // }
    //   return null;
    // }

    final scoresResult = ref
        .watch(assignedCoursesNotifierProvider)
        .scores
        .where(
          (e) => e.afterLesson == widget.afterLesson && e.targetType == "IndividualAssignment",
        )
        .toList();
    // print("scoresResult: $scoresResult");
    Score? score = scoresResult.isNotEmpty ? scoresResult.first : null;
    print("isPastLesson: $isPastLesson && ${score ?? "null"}");
    if (isPastLesson && score == null) {
      score = Score(
        id: "id",
        targetType: "IndividualAssignment",
        targetId: 'testAttempt.id',
        score: 0,
        gradeWaiting: false,
        outOf: constScore?.totalScore ?? 0,
        afterLesson: widget.afterLesson,
        userId: "userId",
        date: DateTime.now(),
      );
    }
    return score;
  }

  Color getColor(double prcnt) {
    prcnt = prcnt * 100;
    if (prcnt < 50) {
      return Colors.red;
    } else {
      return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final authState = ref.watch(authNotifierProvider);
    constScore = ConstScore.get(
        ScoreNames.IndividualAssignment, ref, authState.scores ?? []);

    Score? score = getScore();
    print("score: $score");

    return Container(
      // key:_key,
      margin: EdgeInsets.only(
        top: 10,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
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
                                child: Row(mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 3,
                                        vertical: .5,
                                      ),
                                      decoration: BoxDecoration(
                                        border: score != null
                                            ? Border.all(
                                                color: score.gradeWaiting
                                                    ? primaryColor
                                                    : getColor(
                                                        score.score / score.outOf,
                                                      ),
                                              )
                                            : Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: score != null
                                          ? Text(
                                              score.gradeWaiting
                                                  ? "እየታረመ ነው"
                                                  : "${score.score}/${score.outOf} ነጥብ",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: score.gradeWaiting
                                                    ? primaryColor
                                                    : getColor(
                                                        score.score / score.outOf,
                                                      ),
                                              ),
                                            )
                                          : Text(
                                              "${constScore?.totalScore ?? "..."} ነጥብ",
                                              style: TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                    ),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(authNotifierProvider.notifier)
                                            .showScoringRulesDialog(
                                              context,
                                              byForce: true,
                                            );
                                      },
                                      child: Icon(
                                        Icons.info_outlined,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: widget.isCurrent && score == null
                    //       ? BouncyElevatedButton(
                    //           child: ElevatedButton(
                    //             onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) =>
                                  //         QuestionPage(widget.examData.title),
                                  //   ),
                                  // );
                    //             },
                    //             style: ElevatedButton.styleFrom(
                    //               backgroundColor: Colors.purple,
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(50),
                    //               ),
                    //             ),
                    //             child: const Text(
                    //               "ፈተናውን ጀምር",
                    //               style: TextStyle(
                    //                 fontSize: 16,
                    //                 color: whiteColor,
                    //               ),
                    //             ),
                    //           ),
                    //         )
                    //       : SizedBox(),
                    // ),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme == ThemeMode.light
                      ? Colors.white60
                      : Colors.black54,
                ),
              ),
            ),
            
        ],
      ),
    );
  
  }
}
