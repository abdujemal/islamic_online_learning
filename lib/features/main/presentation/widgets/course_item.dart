// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/course_detail.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

class CourseItem extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const CourseItem(this.courseModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseItemState();
}

class _CourseItemState extends ConsumerState<CourseItem> {
  bool isFav = false;
  int? id;

  @override
  void initState() {
    super.initState();
    isFav = widget.courseModel.isFav;
    id = widget.courseModel.id;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetail(widget.courseModel),
          ),
        );
      },
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: primaryColor,
                ),
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.courseModel.image),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Text(
                          widget.courseModel.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isFav) {
                          if (widget.courseModel.isDownloaded) {
                            await ref
                                .read(mainNotifierProvider.notifier)
                                .saveCourse(widget.courseModel, false);
                          } else {
                            ref
                                .read(favNotifierProvider.notifier)
                                .deleteCourse(id);
                          }
                          setState(() {
                            isFav = false;
                          });
                        } else {
                          await ref
                              .read(mainNotifierProvider.notifier)
                              .saveCourse(widget.courseModel, true);

                          setState(() {
                            isFav = true;
                          });
                        }
                      },
                      child: isFav
                          ? const Icon(
                              Icons.bookmark,
                              size: 30,
                              color: Colors.amber,
                            )
                          : const Icon(
                              Icons.bookmark_border_outlined,
                              size: 30,
                            ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    right: 10,
                    left: 2,
                  ),
                  height: 20,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        topRight: Radius.circular(15),
                      ),
                      color: Colors.amber),
                  child: Text(widget.courseModel.ustaz),
                ),
              ),
              if (widget.courseModel.category != "")
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      right: 10,
                      left: 5,
                    ),
                    height: 20,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomRight: Radius.circular(15),
                        ),
                        color: Colors.amber),
                    child: Text(widget.courseModel.category),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}