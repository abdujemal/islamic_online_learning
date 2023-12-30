// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/data/course_detail_data_src.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/cd_notofier.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

class DownloadAllFiles extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  final void Function(String filePath) onSingleDownloadDone;
  const DownloadAllFiles({
    super.key,
    required this.courseModel,
    required this.onSingleDownloadDone,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DownloadAllFilesState();
}

class _DownloadAllFilesState extends ConsumerState<DownloadAllFiles> {
  bool breakIt = false;
  CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1))
        .then((value) => downloadAllFiles());
  }

  downloadAllFiles() async {
    if (kDebugMode) {
      print("started");
    }
    CDNotifier cdNotifier = ref.read(cdNotifierProvider.notifier);
    // downloading the pdf
    cancelToken = CancelToken();

    if (widget.courseModel.pdfId.trim().isNotEmpty) {
      List<String> pdfIds = widget.courseModel.pdfId.split(',');

      int i = 1;
      for (String pdfId in pdfIds) {
        final bool isPdfDownloaded = await cdNotifier.isDownloaded(
          "${widget.courseModel.title} $i.pdf",
          "PDF",
          context,
        );
        if (!isPdfDownloaded) {
          await cdNotifier.downloadFile(
            pdfId,
            widget.courseModel.pdfId.contains(",")
                ? "${widget.courseModel.title} $i.pdf"
                : "${widget.courseModel.title}.pdf",
            "PDF",
            cancelToken,
            context,
          );
        }
        i++;
      }
    }

    List<String> audioIds = widget.courseModel.courseIds.split(',');

    int i = 0;
    for (String audioId in audioIds) {
      cancelToken = CancelToken();
      if (breakIt) {
        break;
      }
      i++;
      final bool isAudioDownloaded = await cdNotifier.isDownloaded(
          '${widget.courseModel.ustaz},${widget.courseModel.title} $i.mp3',
          "Audio",
          context);
      if (kDebugMode) {
        print(isAudioDownloaded);
      }
      if (!isAudioDownloaded) {
        final file = await cdNotifier.downloadFile(
          audioId,
          '${widget.courseModel.ustaz},${widget.courseModel.title} $i.mp3',
          "Audio",
          cancelToken,
          context,
        );
        if (file != null) {
          widget.onSingleDownloadDone(file.path);
        }
      }
      if (mounted && i == audioIds.length) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progs = ref.watch(downloadProgressProvider);
    return PopScope(
      // onWillPop: () async {
      //   return false;
      // },
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                "ዳውንሎድ በማድረግ ላይ",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              progs.isEmpty
                  ? const Text("ትንሽ ይጠብቁ...")
                  : Expanded(
                      child: ListView.builder(
                        itemCount: progs.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(progs[index].title),
                          subtitle: Column(
                            children: [
                              LinearProgressIndicator(
                                value: progs[index].progress / 100,
                                color: primaryColor,
                                backgroundColor: Theme.of(context).dividerColor,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "${progs[index].progress.toStringAsFixed(2)}% አልቋል"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    breakIt = true;
                    cancelToken.cancel();
                    Navigator.pop(context);
                  },
                  child: const Text("አጥፋው"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
