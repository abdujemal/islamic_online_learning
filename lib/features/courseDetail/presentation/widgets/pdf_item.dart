// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/pdf_page.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';

import '../../data/course_detail_data_src.dart';

class PdfItem extends ConsumerStatefulWidget {
  final String fileId;
  final String path;
  final CourseModel courseModel;
  const PdfItem({
    super.key,
    required this.fileId,
    required this.path,
    required this.courseModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfItemState();
}

class _PdfItemState extends ConsumerState<PdfItem> {
  // bool isLoading = false;
  bool isDownloaded = false;

  @override
  void initState() {
    super.initState();

    checkFile();
  }

  checkFile() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      ref
          .read(cdNotifierProvider.notifier)
          .isDownloaded("${widget.courseModel.title}.pdf", "PDF")
          .then((value) {
        setState(() {
          isDownloaded = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final downLoadProg =
        ref.watch(downloadProgressCheckernProvider.call(widget.path));
    // if (downLoadProg != null) {
    //   print(downLoadProg.filePath);
    //   print(widget.path);
    // }
    return ListTile(
      onTap: () async {
        ref
            .read(cdNotifierProvider.notifier)
            .downloadFile(
                widget.fileId, "${widget.courseModel.title}.pdf", 'PDF')
            .then((file) {
          if (file != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PdfPage(
                  path: file.path,
                  courseModel: widget.courseModel,
                ),
              ),
            );
          }

          checkFile();
        });
      },
      leading: const Icon(Icons.book),
      title: Text(widget.courseModel.title),
      subtitle: downLoadProg != null
          ? LinearProgressIndicator(
              value: downLoadProg.progress / 100,
              backgroundColor: Colors.black26,
              color: primaryColor,
            )
          : null,
      trailing: isDownloaded
          ? SizedBox(
              width: 80,
              child: Row(
                children: [
                  const Icon(
                    Icons.download_done,
                    color: Colors.green,
                  ),
                  IconButton(
                    onPressed: () async {
                      await ref
                          .read(cdNotifierProvider.notifier)
                          .deleteFile('${widget.courseModel.title}.pdf', "PDF");

                      checkFile();
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                ],
              ))
          : const Icon(Icons.download),
    );
  }
}
