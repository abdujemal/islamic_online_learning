import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

import '../../../../core/constants.dart';

class UpdateAllCourses extends ConsumerStatefulWidget {
  final List<CourseModel> courses;
  const UpdateAllCourses(this.courses, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateAllCoursesState();
}

class _UpdateAllCoursesState extends ConsumerState<UpdateAllCourses> {
  String currentCourse = "Starting";

  int i = 0;
  List<String> wrongurls = [];

  @override
  void initState() {
    super.initState();
    updateAllCourses();
  }

  Future<void> updateAllCourses() async {
    wrongurls = [];
    for (CourseModel cm in widget.courses) {
      currentCourse = "${cm.title} by ${cm.ustaz}";
      setState(() {});
      i = 0;
      // for (String audioId in cm.courseIds.split(",")) {
      //   i++;

      //   final url =
      //       await ref.read(cdNotifierProvider.notifier).loadFileOnline(audioId, true);

      // setState(() {});
      // }
      final newImage = cm.image.replaceAll(
          "https://f005.backblazeb2.com", "https://b2.ilmfelagi.com");

      final newPdf = cm.pdfId.replaceAll(
          "https://f005.backblazeb2.com", "https://b2.ilmfelagi.com");

      final newAudio = cm.courseIds.replaceAll(
          "https://f005.backblazeb2.com", "https://b2.ilmfelagi.com");

      await FirebaseFirestore.instance
          .collection(FirebaseConst.courses)
          .doc(cm.courseId)
          .update(
            cm
                .copyWith(
                  image: newImage,
                  pdfId: newPdf,
                  courseIds: newAudio,
                )
                .toOriginalMap(),
          );

      // if (urls.length == cm.courseIds.split(",").length) {
      //   FirebaseFirestore.instance
      //       .collection(FirebaseConst.courses)
      //       .doc(cm.courseId)
      //       .update(cm.copyWith(courseIds: urls.join(",")).toOriginalMap());
      // } else {
      //   break;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text(currentCourse),
                subtitle: Text("Audio $i"),
                trailing: const Text("Updateing ..."),
              ),
              const ListTile(
                title: Text("Wrong audios"),
              ),
              ...List.generate(
                  wrongurls.length, (index) => Text(wrongurls[index]))
            ],
          ),
        ),
      ),
    );
  }
}
