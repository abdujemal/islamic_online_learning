// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/widgets/list_title.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/audio_item.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';
import '../widgets/pdf_item.dart';

class CourseDetail extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const CourseDetail({
    super.key,
    required this.courseModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseDetailState();
}

class _CourseDetailState extends ConsumerState<CourseDetail> {
  List<String> audios = [];

  String? pdfPath;

  @override
  void initState() {
    super.initState();
    audios = widget.courseModel.courseIds.split(",");

    getPath('PDF', "${widget.courseModel.title}.pdf").then((value) {
      pdfPath = value;
      setState(() {});
    });
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    final currentAudio = ref.watch(currentAudioProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseModel.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            currentAudio != null ? 60 : 0,
          ),
          child: currentAudio != null
              ? CurrentAudioView(currentAudio)
              : const SizedBox(),
        ),
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
            height: MediaQuery.of(context).size.height * 0.32,
            width: MediaQuery.of(context).size.width,
            color: Colors.black26,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.16),
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  width: 240,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "ደርሱን ጀምር",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
            padding: const EdgeInsets.only(
              top: 20,
            ),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ListTitle(
                      title: "ኪታብን ያቀራው እስተማሪ",
                    ),
                  ),
                  ListTile(
                    title: Text(widget.courseModel.ustaz),
                    leading: const Icon(Icons.mic),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ListTitle(
                      title: "ምድብ",
                    ),
                  ),
                  ListTile(
                    title: Text(widget.courseModel.category),
                    leading: const Icon(Icons.category_rounded),
                  ),
                  if (widget.courseModel.author.trim().isNotEmpty)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: ListTitle(
                        title: "የኪታቡ ጸሃፊ",
                      ),
                    ),
                  if (widget.courseModel.author.trim().isNotEmpty)
                    ListTile(
                      title: Text(widget.courseModel.author),
                      leading: const Icon(Icons.edit_document),
                    ),
                  if (!widget.courseModel.isStarted &&
                      widget.courseModel.pdfId != "")
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: ListTitle(
                        title: "ኪታብ በሶፍት ኮፒ",
                      ),
                    ),
                  if (!widget.courseModel.isStarted &&
                      widget.courseModel.pdfId != "" &&
                      pdfPath != null)
                    PdfItem(
                      fileId: widget.courseModel.pdfId,
                      path: pdfPath!,
                      courseModel: widget.courseModel,
                    ),
                  if (!widget.courseModel.isStarted)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: ListTitle(
                        title: "ድምጾች",
                      ),
                    ),
                  ...List.generate(
                    audios.sublist(0, 2).length,
                    (index) => AudioItem(
                        audios[index],
                        "${widget.courseModel.title} ${index + 1}",
                        widget.courseModel,
                        false),
                  ),
                  if (!widget.courseModel.isStarted && audios.length > 2)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text("በተጨማሪ  ${audios.length - 2} ድምጾች እሉ።"),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
