// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/audio_bottom_view.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/pdf_drawer.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';

import '../../../../core/Audio Feature/audio_providers.dart';
import '../../../../core/Audio Feature/current_audio_view.dart';
import '../../../main/data/model/course_model.dart';

class PdfPage extends ConsumerStatefulWidget {
  final String path;
  final int pageNum;
  final CourseModel courseModel;
  const PdfPage({
    super.key,
    required this.path,
    this.pageNum = 0,
    required this.courseModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfPageState();
}

class _PdfPageState extends ConsumerState<PdfPage> {
  late PDFViewController pdfViewController;

  int? pages;

  int? currentPage;

  bool? isReady;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  Widget build(BuildContext context) {
    final currentAudio = ref.watch(currentAudioProvider);
    final currentCourse = ref.watch(checkCourseProvider
        .call(widget.courseModel.courseId)); // returns the course if it matches

    final theme = ref.read(themeProvider);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.courseModel.title),
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: const Icon(Icons.music_note),
        ),
        bottom: PreferredSize(
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            currentAudio != null && currentCourse == null ? 60 : 0,
          ),
          child: currentAudio != null && currentCourse == null
              ? CurrentAudioView(currentAudio)
              : const SizedBox(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text("ድምጾች"),
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      drawer: PdfDrawer(
        audios: widget.courseModel.courseIds.split(","),
        title: widget.courseModel.title,
        courseModel: widget.courseModel,
      ),
      bottomNavigationBar: AudioBottomView(widget.courseModel.courseId),
      body: PDFView(
        filePath: widget.path,
        pageSnap: false,
        autoSpacing: false,
        nightMode: theme == ThemeMode.dark,
        pageFling: false,
        onRender: (pgs) {
          setState(() {
            pages = pgs;
            isReady = true;
          });
        },
        onError: (error) {
          toast(error, ToastType.error);
        },
        onPageError: (page, error) {
          toast('$page: ${error.toString()}', ToastType.error);
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _controller.complete(pdfViewController);
        },
        onPageChanged: (int? page, int? total) {
          if (page != null && total != null) {
            currentPage = page;
            toast("${page + 1} / ${total + 1}", ToastType.normal);
          }
        },
      ),
    );
  }
}
