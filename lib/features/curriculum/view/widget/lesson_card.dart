import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
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
                          Icons.book_outlined,
                          color: primaryColor,
                          size: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 6,
                          children: [
                            Text(
                              "ትምህርት",
                              style: TextStyle(
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              widget.lesson.title,
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
                                "10 ነጥብ",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: widget.isCurrentLesson
                          ? ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.circular(12),
                                    ),
                              ),
                              child: const Text(
                                "ጀምር",
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
