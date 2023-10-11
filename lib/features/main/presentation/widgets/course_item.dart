import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';

class CourseItem extends StatelessWidget {
  final CourseModel courseModel;
  const CourseItem(this.courseModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("object");
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
                          image: NetworkImage(courseModel.image),
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
                          courseModel.title,
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
                    const Icon(
                      Icons.bookmark_border_outlined,
                      size: 30,
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
                  child: Text(courseModel.ustaz),
                ),
              ),
              if (courseModel.category != "")
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
                    child: Text(courseModel.category),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
