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
  final String title;
  final double volume;
  final CourseModel courseModel;
  final VoidCallback whenPop;
  const PdfItem({
    super.key,
    required this.title,
    required this.volume,
    required this.fileId,
    required this.path,
    required this.courseModel,
    required this.whenPop,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfItemState();
}

class _PdfItemState extends ConsumerState<PdfItem> {
  CancelToken cancelToken = CancelToken();

  Future<bool> checkFile() async {
    if (mounted) {
      return await ref
          .read(cdNotifierProvider.notifier)
          .isDownloaded("${widget.title}.pdf", "PDF", widget.fileId, context);
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final downLoadProg =
        ref.watch(downloadProgressCheckernProvider.call(widget.path));

    return FutureBuilder(
        future: checkFile(),
        builder: (context, snap) {
          bool isDownloaded = snap.data ?? false;
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
                  return;
                }
                ref
                    .read(cdNotifierProvider.notifier)
                    .downloadFile(
                      widget.fileId,
                      "${widget.title}.pdf",
                      'PDF',
                      cancelToken,
                      context,
                    )
                    .then((file) async {
                  if (file != null) {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfPage(
                            volume: widget.volume,
                            path: file.path,
                            courseModel: widget.courseModel,
                          ),
                        ),
                      ).then((value) {
                        widget.whenPop();
                      });
                    }
                  }

                  isDownloaded = await checkFile();
                  if (mounted) {
                    setState(() {});
                  }
                });
              },
              leading: const Icon(Icons.menu_book_rounded),
              title: Text(widget.title),
              subtitle: downLoadProg != null
                  ? Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: downLoadProg.progress / 100,
                            backgroundColor: Colors.black26,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: const Icon(Icons.close_rounded),
                          onTap: () {
                            downLoadProg.cancelToken.cancel();
                            cancelToken = CancelToken();
                            return;
                          },
                        )
                      ],
                    )
                  : isDownloaded
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "ኪታቡን ክፈት",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : null,
              trailing: isDownloaded && downLoadProg == null
                  ? IconButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => DeleteConfirmation(
                            title: '${widget.title}.pdf',
                            action: () async {
                              await ref
                                  .read(cdNotifierProvider.notifier)
                                  .deleteFile(
                                      '${widget.title}.pdf', "PDF", context);
                              isDownloaded = await checkFile();
                              setState(() {});
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                      ),
                    )
                  : downLoadProg != null
                      ? Text(
                          "${downLoadProg.progress.toStringAsFixed(2)}%",
                        )
                      : const Icon(Icons.download_rounded),
            ),
          );
        });
  }
}
