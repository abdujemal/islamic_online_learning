import 'package:flutter/material.dart';
import 'package:hijri_calendar/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:islamic_online_learning/core/constants.dart';

class LearningHomePage extends StatefulWidget {
  const LearningHomePage({super.key});

  @override
  State<LearningHomePage> createState() => _LearningHomePageState();
}

class _LearningHomePageState extends State<LearningHomePage> {
  int currentCourseIndex = 0;
  int currentLessonIndex = 1; // lesson 1 is current

  final List<Map<String, dynamic>> courses = [
    {
      'title': 'أساسيات الفقه',
      'lessons': ['الطهارة', 'الصلاة', 'الزكاة', 'الصوم'],
    },
    {
      'title': 'العقيدة الإسلامية',
      'lessons': ['أركان الإيمان', 'التوحيد', 'الشرك', 'اليوم الآخر'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final hijri = HijriCalendarConfig.now();

    final arabicDate = "${hijri.fullDate()} هـ";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          // Greeting
          Text(
            "السلام عليكم ورحمة الله وبركاته",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor.shade700,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            arabicDate,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          // Courses & Lessons
          ...courses.asMap().entries.map((courseEntry) {
            final courseIndex = courseEntry.key;
            final course = courseEntry.value;

            final bool isCurrentCourse = courseIndex == currentCourseIndex;
            final bool isPastCourse = courseIndex < currentCourseIndex;
            final bool isFutureCourse = courseIndex > currentCourseIndex;

            return ExpansionTile(
              initiallyExpanded: isCurrentCourse,
              title: Row(
                children: [
                  Text(
                    course['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          isFutureCourse ? Colors.grey : primaryColor.shade700,
                    ),
                  ),
                  if (isFutureCourse)
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(Icons.lock, size: 18, color: Colors.grey),
                    ),
                ],
              ),
              children: (course['lessons'] as List<String>)
                  .asMap()
                  .entries
                  .map((lessonEntry) {
                final lessonIndex = lessonEntry.key;
                final lessonTitle = lessonEntry.value;

                // Determine state of lesson
                final bool isCurrentLesson =
                    isCurrentCourse && lessonIndex == currentLessonIndex;
                final bool isPastLesson =
                    isCurrentCourse && lessonIndex < currentLessonIndex;
                final bool isLocked = isFutureCourse ||
                    (isCurrentCourse && lessonIndex > currentLessonIndex);

                return ListTile(
                  title: Text(
                    lessonTitle,
                    style: TextStyle(
                      color: isLocked ? Colors.grey : Colors.white,
                    ),
                  ),
                  trailing: isCurrentLesson
                      ? ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "تابع",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : isPastLesson
                          ? OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor.shade700,
                                side: BorderSide(color: primaryColor.shade700),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text("مراجعة"),
                            )
                          : const Icon(Icons.lock, color: Colors.grey),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
