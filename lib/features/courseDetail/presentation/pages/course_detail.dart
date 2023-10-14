import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';

class CourseDetail extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const CourseDetail(this.courseModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseDetailState();
}

class _CourseDetailState extends ConsumerState<CourseDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseModel.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.network(
            widget.courseModel.image,
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: ListView.builder(
              itemCount: widget.courseModel.courseIds.split(",").length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                child: ListTile(
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                  ),
                  title: Text("${widget.courseModel.title} ${index + 1}"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
