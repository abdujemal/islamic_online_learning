// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/pdf_page.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

import '../../data/course_detail_data_src.dart';
import 'delete_confirmation.dart';

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

  CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      checkFile();
    });
  }

  checkFile() {
    if (mounted) {
      ref
          .read(cdNotifierProvider.notifier)
          .isDownloaded("${widget.courseModel.title}.pdf", "PDF")
          .then((value) {
        if (mounted) {
          setState(() {
            isDownloaded = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final downLoadProg =
        ref.watch(downloadProgressCheckernProvider.call(widget.path));

    // checkFile();
    print("pdf item");

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            offset: const Offset(0, 3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(5),
      child: ListTile(
        onTap: () async {
          if (downLoadProg != null) {
            cancelToken.cancel();
            cancelToken = CancelToken();
            return;
          }
          ref
              .read(cdNotifierProvider.notifier)
              .downloadFile(
                widget.fileId,
                "${widget.courseModel.title}.pdf",
                'PDF',
                cancelToken,
              )
              .then((file) {
            if (file != null) {
              if (mounted) {
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
            }

            checkFile();
          });
        },
        leading: const Icon(Icons.menu_book_sharp),
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
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => DeleteConfirmation(
                            title: '${widget.courseModel.title}.pdf',
                            action: () async {
                              await ref
                                  .read(cdNotifierProvider.notifier)
                                  .deleteFile(
                                      '${widget.courseModel.title}.pdf', "PDF");
                              checkFile();
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ))
            : const Icon(Icons.download),
      ),
    );
  }
}
