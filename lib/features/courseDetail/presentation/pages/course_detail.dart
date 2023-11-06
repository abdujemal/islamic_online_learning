// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/core/widgets/list_title.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/audio_item.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/download_all_files.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/schedule_veiw.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';
import '../widgets/audio_bottom_view.dart';
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

    print(audios.length);
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    final currentAudio = ref.watch(currentAudioProvider);
    final currentCourse = ref.watch(checkCourseProvider
        .call(widget.courseModel.courseId)); // returns the course if it matches

    return Scaffold(
      bottomNavigationBar: AudioBottomView(widget.courseModel.courseId),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.32,
              collapsedHeight: 60,
              title: Text(widget.courseModel.title),
              floating: false,
              pinned: true,
              snap: false,
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          DownloadAllFiles(widget.courseModel),
                    );
                  },
                  icon: const Icon(Icons.download_rounded),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size(
                  MediaQuery.of(context).size.width,
                  currentAudio != null && currentCourse == null ? 40 : 0,
                ),
                child: currentAudio != null && currentCourse == null
                    ? CurrentAudioView(currentAudio)
                    : const SizedBox(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.fadeTitle],
                collapseMode: CollapseMode.pin,
                centerTitle: true,
                background: Stack(
                  children: [
                    FutureBuilder(
                        future: displayImage(
                          widget.courseModel.image,
                          widget.courseModel.title,
                          ref,
                        ),
                        builder: (context, snap) {
                          return snap.data == null
                              ? SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.32,
                                  width: MediaQuery.of(context).size.width,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  ),
                                )
                              : snap.data!.path.isEmpty
                                  ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.32,
                                      width: MediaQuery.of(context).size.width,
                                      child: const Center(
                                        child: Icon(Icons.error_rounded),
                                      ),
                                    )
                                  : SizedBox(
                                      // height:
                                      //     MediaQuery.of(context).size.height *
                                      //         0.32,
                                      // width:
                                      //     MediaQuery.of(context).size.width,
                                      child: Image.file(
                                        snap.data!,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.32,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.fill,
                                      ),
                                    );
                        }),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.32,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black26,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () async {
                          //                   final bool status = await FlutterOverlayWindow.isPermissionGranted();

                          //  /// request overlay permission
                          //  /// it will open the overlay settings page and return `true` once the permission granted.
                          //  final bool? status1 = await FlutterOverlayWindow.requestPermission();
                          showDialog(
                            context: context,
                            builder: (ctx) => ScheduleView(widget.courseModel),
                          );
                        },
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
                                Icons.alarm_add_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "አስታዋሽ መዝግብ",
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
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: ListTitle(
                            title: "ኪታብን ያቀራው ኡስታዝ",
                          ),
                        ),
                        ListTile(
                          title: Text(widget.courseModel.ustaz),
                          leading: const Icon(Icons.mic_rounded),
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
                            widget.courseModel.pdfId.trim() != "")
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: ListTitle(
                              title: "ኪታብ በሶፍት ኮፒ",
                            ),
                          ),
                        if (!widget.courseModel.isStarted &&
                            widget.courseModel.pdfId.trim() != "" &&
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
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    );
                  } else if (index > 0) {
                    return AudioItem(
                      audioId: audios[index - 1],
                      title: widget.courseModel.title,
                      index: index,
                      courseModel: widget.courseModel,
                      isFromPDF: false,
                      onDownloadDone: () {},
                    );
                  } else {
                    return SizedBox();
                  }
                },
                childCount: audios.length + 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
