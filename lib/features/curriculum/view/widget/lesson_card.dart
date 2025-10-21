import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/lib/static_datas.dart';
import 'package:islamic_online_learning/features/auth/model/const_score.dart';
import 'package:islamic_online_learning/features/auth/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class LessonCard extends ConsumerStatefulWidget {
  final bool isCurrentLesson;
  final bool isPastLesson;
  final bool isLocked;
  final Lesson lesson;
  const LessonCard({
    required this.isCurrentLesson,
    required this.isPastLesson,
    required this.isLocked,
    required this.lesson,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonCardState();
}

class _LessonCardState extends ConsumerState<LessonCard> {
  final GlobalKey _key = GlobalKey();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final box = _key.currentContext?.findRenderObject() as RenderBox?;
  //     if (box != null) {
  //       print("Lesson card: ${box.size.height}");
  //     }
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final authState = ref.watch(authNotifierProvider);
    final score = ConstScore.get(ScoreNames.Lesson, ref, authState.scores ?? []);
    final assignedCourse = ref
        .watch(assignedCoursesNotifierProvider)
        .curriculum
        ?.assignedCourses
        ?.firstWhere((element) => element.id == widget.lesson.assignedCourseId);
    final lessonState = ref.watch(lessonNotifierProvider);
    // final downLoadProg =
    //     ref.watch(downloadProgressCheckernProvider.call(audioPath));
    final isDownloading = lessonState.isDownloading &&
        lessonState.currentLesson?.id == widget.lesson.id;

    return Container(
      key: _key,
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
                          Icons.book_outlined,
                          color: primaryColor,
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
                                    "ትምህርት",
                                    style: TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    widget.lesson.title,
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
                      child: widget.isCurrentLesson
                          ? ElevatedButton(
                              onPressed: () {
                                if (assignedCourse == null) {
                                  print("assignedCourse: null");
                                  return;
                                }
                                ref
                                    .read(lessonNotifierProvider.notifier)
                                    .startLesson(
                                        widget.lesson, assignedCourse, ref);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.circular(12),
                                    ),
                              ),
                              child: Text(
                                isDownloading ? "ኪታቡን ዳውንሎድ በማረግ ላይ..." : "ጀምር",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: whiteColor,
                                ),
                              ),
                            )
                          : widget.isPastLesson
                              ? OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.all(0),
                                    foregroundColor: primaryColor,
                                    side: BorderSide(color: primaryColor),
                                    shape: RoundedRectangleBorder(
                                        // borderRadius: BorderRadius.circular(12),
                                        ),
                                  ),
                                  child: const Text("ክፈት"),
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
