import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilteredCourses extends ConsumerStatefulWidget {
  final String keey;
  final String value;
  const FilteredCourses(this.keey, this.value, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilteredCoursesState();
}

class _FilteredCoursesState extends ConsumerState<FilteredCourses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.value),
      ),
    );
  }
}
