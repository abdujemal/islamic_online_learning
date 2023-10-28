// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/audio_bottom_view.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/pdf_drawer.dart';

import '../../../main/data/course_model.dart';

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

  bool? isReady;

  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  @override
  void initState() {
    super.initState();
    print(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseModel.title),
        // leading: IconButton(
        //   onPressed: () {
        //     context.op
        //   },
        //   icon: const Icon(Icons.music_note),
        // ),
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
        pageFling: false,
        onRender: (_pages) {
          setState(() {
            pages = _pages;
            isReady = true;
          });
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _controller.complete(pdfViewController);
        },
        onPageChanged: (int? page, int? total) {
          if (page != null && total != null) {
            toast("${page + 1} / ${total + 1}", ToastType.normal);
          }
        },
      ),
    );
  }
}
