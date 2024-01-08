import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio/just_audio.dart';

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
  int totalDuration = 0;
  bool jumpIt = false;

  @override
  void initState() {
    super.initState();

    updateAllCourses();
  }

  // Future<int> getMusicDurationFromUrl(String url) async {
  //   final dio = Dio();
  //   final response = await dio.head(url);

  //   final headers = response.headers;
  //   final contentLength = headers.value('content-length');

  //   final durationInSeconds = int.parse(contentLength!) /
  //       44100; // Assuming the music file has a sample rate of 44100

  //   final duration = Duration(seconds: durationInSeconds.round());

  //   print('Music duration: ${duration.toString()}');
  //   return duration.inSeconds;
  // }

  Future<void> updateAllCourses() async {
    wrongurls = [];
    for (CourseModel cm in widget.courses) {
      if (cm.totalDuration > 0) {
        continue;
      }
      currentCourse = "${cm.noOfRecord} ${cm.ustaz}${cm.title}";
      setState(() {});

      i = 0;
      totalDuration = 0;
      print("prev Durtaion: $totalDuration");
      for (String audioId in cm.courseIds.split(",").sublist(195)) {
        i++;
        if (jumpIt) {
          break;
        }

        AudioPlayer player = AudioPlayer();
        while (true) {
          // Future<int> getMusicDurationFromUrl(String url) async {
          //   final dio = Dio();
          //   final response = await dio.head(url);

          //   final headers = response.headers;
          //   final contentLength = headers.value('content-length');

          //   final durationInSeconds = int.parse(contentLength!) /
          //       44100; // Assuming the music file has a sample rate of 44100

          //   final duration = Duration(seconds: durationInSeconds.round());

          //   print('Music duration: ${duration.toString()}');
          //   return duration.inSeconds;
          // }
          try {
            final duration = await player.setUrl(audioId);
            //  await getMusicDurationFromUrl(
            //   audioId,
            // );
            if (duration != null) {
              print("duration ${duration.toString()}");
              totalDuration = totalDuration + duration.inSeconds;

              print("index $i");
              print(audioId);

              setState(() {});
              break;
            } else {
              wrongurls.add("${cm.title} by ${cm.ustaz} $i");
              setState(() {});
            }
          } catch (e) {
            if (mounted) {
              toast(e.toString(), ToastType.error, context);
              print(audioId);
            }
            // wrongurls.add("${cm.title} by ${cm.ustaz} $i");
          }
        }
      }
      if (jumpIt) {
        jumpIt = false;
      } else {
        await FirebaseFirestore.instance
            .collection(FirebaseConst.courses)
            .doc(cm.courseId)
            .update(
              cm
                  .copyWith(
                    totalDuration: totalDuration,
                  )
                  .toOriginalMap(),
            );
      }
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
              TextButton(
                onPressed: () {
                  jumpIt = true;
                },
                child: const Text("Jump It"),
              ),
              ListTile(
                title: Text(currentCourse),
                subtitle: Text("Audio $i"),
                trailing: const Text("Updateing ..."),
              ),
              ListTile(
                title: Text("Wrong audios ${wrongurls.length}"),
                trailing: IconButton(
                  onPressed: () {
                    wrongurls = [];
                    setState(() {});
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
              // SizedBox(
              //   height: 150,
              //   width: MediaQuery.of(context).size.width - 30,
              //   child: ListView.builder(
              //     itemCount: wrongurls.length,
              //     itemBuilder: (context, index) => Text(wrongurls[index]),
              //   ),
              // )
              // ...List.generate(
              //     wrongurls.length, (index) => Text(wrongurls[index]))
            ],
          ),
        ),
      ),
    );
  }
}
