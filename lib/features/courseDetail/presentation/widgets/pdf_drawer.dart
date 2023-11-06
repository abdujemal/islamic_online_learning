// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main/data/model/course_model.dart';
import 'audio_item.dart';

class PdfDrawer extends ConsumerStatefulWidget {
  final List<String> audios;
  final String title;
  final CourseModel courseModel;
  const PdfDrawer({
    super.key,
    required this.audios,
    required this.title,
    required this.courseModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfDrawerState();
}

class _PdfDrawerState extends ConsumerState<PdfDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 10,
              right: 5,
              left: 5,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Center(
              child: Text(
                "የ${widget.title} ድምጾች",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.audios.length,
              itemBuilder: (context, index) => AudioItem(
                audioId: widget.audios[index],
                title: widget.courseModel.title,
                index: index + 1,
                courseModel: widget.courseModel,
                isFromPDF: false,
                onDownloadDone: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
