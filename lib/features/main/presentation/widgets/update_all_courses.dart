
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

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
      for (String audioId in cm.courseIds.split(",")) {
        i++;
        await Future.delayed(const Duration(milliseconds: 100));
        // final url =
        //     await ref.read(cdNotifierProvider.notifier).loadFileOnline(audioId, true);
        if (!audioId.contains("https://")) {
          wrongurls.add("${cm.title} on audio $i");
        }
        setState(() {});
      }
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
