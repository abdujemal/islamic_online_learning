import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignedCourseList extends ConsumerStatefulWidget {
  const AssignedCourseList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AssignedCourseListState();
}

class _AssignedCourseListState extends ConsumerState<AssignedCourseList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Assigned Courses"),
    );
  }
}