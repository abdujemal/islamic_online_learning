import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/data/course_detail_data_src.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/cd_notofier.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

class DownloadAllFiles extends ConsumerStatefulWidget {
  final CourseModel courseModel;
  const DownloadAllFiles(this.courseModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DownloadAllFilesState();
}

class _DownloadAllFilesState extends ConsumerState<DownloadAllFiles> {
  bool breakIt = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1))
        .then((value) => downloadAllFiles());
  }

  downloadAllFiles() async {
    print("started");
    CDNotifier cdNotifier = ref.read(cdNotifierProvider.notifier);
    // downloading the pdf
    if (widget.courseModel.pdfId.trim().isNotEmpty) {
      final bool isPdfDownloaded = await cdNotifier.isDownloaded(
        "${widget.courseModel.title}.pdf",
        "PDF",
      );
      if (!isPdfDownloaded) {
        await cdNotifier.downloadFile(
          widget.courseModel.pdfId,
          "${widget.courseModel.title}.pdf",
          "PDF",
          CancelToken(),
        );
      }
    }

    List<String> audioIds = widget.courseModel.courseIds.split(',');

    int i = 0;
    for (String audioId in audioIds) {
      if (breakIt) {
        break;
      }
      i++;
      final bool isAudioDownloaded = await cdNotifier.isDownloaded(
        '${widget.courseModel.ustaz},${widget.courseModel.title} $i.mp3',
        "Audio",
      );
      print(isAudioDownloaded);
      if (!isAudioDownloaded) {
        await cdNotifier.downloadFile(
          audioId,
          '${widget.courseModel.ustaz},${widget.courseModel.title} $i.mp3',
          "Audio",
          CancelToken(),
        );
      }
      if (mounted && i == audioIds.length) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final progs = ref.watch(downloadProgressProvider);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
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
                          subtitle: LinearProgressIndicator(
                            value: progs[index].progress / 100,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    breakIt = true;
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
