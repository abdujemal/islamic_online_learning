// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';
// import 'package:islamic_online_learning/features/curriculum/view/widget/discussion_card.dart';
// import 'package:islamic_online_learning/features/curriculum/view/widget/lesson_card.dart';

// class NewLessonStructure extends ConsumerStatefulWidget {
//   const NewLessonStructure({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _NewLessonStructureState();
// }

// class _NewLessonStructureState extends ConsumerState<NewLessonStructure> {
//   @override
//   Widget build(BuildContext context) {
//     final int lessonPerDay = 2;
//     final int noOfLessons = 100;
//     final int lessonNo = 5;
//     final courseStartDay = DateTime.parse("2025-10-08 12:07:58.731");
//     print("weekday: ${courseStartDay.weekday}");
//     List<int> lessonStructure =
//         getLessonStructure(lessonPerDay, courseStartDay, noOfLessons);
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: noOfLessons,
//         itemBuilder: (context, index) {
//           final currentLesson = lessonNo == index;
//           final isPastLesson = lessonNo < index;

//           return Column(
//             children: [
//               // LessonCard(
//               //     isCurrentLesson: currentLesson,
//               //     isPastLesson: isPastLesson,
//               //     isLocked: isPastLesson && !currentLesson,
//               //     lesson: getCurrentLesson(index)),
//               Text("Lesson$index"),
//               if (hasDiscussion(lessonStructure, noOfLessons, index))
//                 Text("Discussion"),
//               if (hasExam(lessonStructure, noOfLessons, index, lessonPerDay))
//                 Text("Exam"),
//             ],
//           );
//         },
//       ),
//     );
//   }

  
// }
