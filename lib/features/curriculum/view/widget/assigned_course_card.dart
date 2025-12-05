import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/view/controller/provider.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/current_lesson_list.dart';
import 'package:islamic_online_learning/features/curriculum/view/widget/past_lesson_list.dart';

class AssignedCourseCard extends ConsumerStatefulWidget {
  final AssignedCourse assignedCourse;
  final bool isCurrentCourse;
  final bool isFutureCourse;

  const AssignedCourseCard({
    super.key,
    required this.assignedCourse,
    required this.isCurrentCourse,
    required this.isFutureCourse,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AssignedCourseCardState();
}

class _AssignedCourseCardState extends ConsumerState<AssignedCourseCard> {
  final GlobalKey _key = GlobalKey();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final box = _key.currentContext?.findRenderObject() as RenderBox?;
  //     if (box != null) {
  //       print("Course card: ${box.size.height}");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final coursesState = ref.watch(assignedCoursesNotifierProvider);

    return Column(
      key: _key,
      children: [
        ExpansionTile(
          enabled: true,
          shape: BeveledRectangleBorder(),
          onExpansionChanged: (value) {
            // ref.read(assignedCoursesNotifierProvider.notifier).changeExpandedCourse(widget.assignedCourse!.order);
            if (!widget.isCurrentCourse && !widget.isFutureCourse) {
              if (value) {
                ref
                    .read(pastLessonStateProvider.notifier)
                    .getLessonForCourse(widget.assignedCourse.id, context);
              }
            }
          },
          initiallyExpanded: widget.isCurrentCourse,
          title: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    border: !widget.isFutureCourse
                        ? Border.all(
                            color: primaryColor,
                          )
                        : Border.all(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Colors.black,
                          ),
                    color: widget.isCurrentCourse
                        ? primaryColor
                        : widget.isFutureCourse
                            ? Colors.transparent
                            : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    widget.isCurrentCourse
                        ? Icons.play_arrow
                        : widget.isFutureCourse
                            ? Icons.lock_outline_rounded
                            : Icons.check_rounded,
                    size: widget.isCurrentCourse ? 30 : 25,
                    weight: 1,
                    color: widget.isCurrentCourse
                        ? whiteColor
                        : Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                SizedBox(
                  width: widget.isFutureCourse ? 16 : 5,
                ),
                if (widget.assignedCourse.course?.image != null)
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: primaryColor,
                      ),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.assignedCourse.course!.image,
                        ),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    widget.assignedCourse.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: widget.isFutureCourse ? Colors.grey : primaryColor,
                    ),
                  ),
                ),
                // if (widget.isFutureCourse)
                //   const Padding(
                //     padding: EdgeInsets.only(left: 8.0),
                //     child: Icon(Icons.lock, size: 18, color: Colors.grey),
                //   ),
              ],
            ),
          ),
          children: [
            if (widget.isFutureCourse) ...[
              Text("ዝግ ነው! እዚህ ጋር ሲደርሱ ይከፈታል!"),
            ] else if (widget.isCurrentCourse) ...[
              CurrentLessonList2(assignedCourse: widget.assignedCourse,)
            ] else ...[
              PastLessonList()
            ]
          ],
        ),
        Divider(
          color: Colors.black12,
        )
      ],
    );
  }
}
