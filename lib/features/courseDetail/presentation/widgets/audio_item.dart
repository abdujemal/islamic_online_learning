// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:islamic_online_learning/core/Audio%20Feature/audio_model.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/download_icon.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';

import '../../data/course_detail_data_src.dart';
import 'delete_confirmation.dart';

class AudioItem extends ConsumerStatefulWidget {
  final String audioId;
  final String title;
  final int index;
  final CourseModel courseModel;
  final bool isFromPDF;
  final VoidCallback onDownloadDone;
  const AudioItem({
    super.key,
    required this.audioId,
    required this.title,
    required this.index,
    required this.courseModel,
    required this.isFromPDF,
    required this.onDownloadDone,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AudioItemState();
}

class _AudioItemState extends ConsumerState<AudioItem> {
  bool isLoading = false;
  // bool isDownloaded = false;
  bool isDownloading = false;

  String? audioPath;

  CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    super.initState();
    // print("${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3");

    getPath('Audio',
            "${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3")
        .then((value) {
      audioPath = value;
      setState(() {});
    });
  }

  Future<bool> checkFile() async {
    if (mounted) {
      final isDownloaded = await ref
          .read(cdNotifierProvider.notifier)
          .isDownloaded(
              "${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3",
              "Audio");
      return isDownloaded;
    }
    return false;
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    AudioState myState = ref.watch(checkAudioModelProvider
        .call("${widget.courseModel.ustaz},${widget.title} ${widget.index}"));

    final downLoadProg =
        ref.watch(downloadProgressCheckernProvider.call(audioPath));

    // checkFile();

    return FutureBuilder(
        future: checkFile(),
        builder: (context, snap) {
          bool isDownloaded = snap.data ?? false;
          return Container(
            decoration: BoxDecoration(
              color: myState.isPlaying() || myState.isPlaused()
                  ? Theme.of(context).chipTheme.backgroundColor!
                  : null,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).chipTheme.backgroundColor!,
                ),
              ),
            ),
            child: ListTile(
              trailing: isDownloaded && downLoadProg?.filePath != audioPath
                  ? IconButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => DeleteConfirmation(
                            title: '${widget.title} ${widget.index}.mp3',
                            action: () async {
                              await ref
                                  .read(cdNotifierProvider.notifier)
                                  .deleteFile(
                                      '${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3',
                                      "Audio");

                              isDownloaded = await checkFile();
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                      ),
                    )
                  : null,
              leading: GestureDetector(
                onTap: () async {
                  print(myState.toString());
                  if (isLoading) {
                    return;
                  }
                  if (myState.isPlaying()) {
                    ref.read(audioProvider).pause();
                    ref.read(currentAudioProvider.notifier).update(
                          (state) => state!.copyWith(
                            audioState: AudioState.paused,
                          ),
                        );
                    return;
                  }
                  if (myState.isPlaused()) {
                    ref.read(audioProvider).play();
                    ref.read(currentAudioProvider.notifier).update(
                          (state) => state!.copyWith(
                            audioState: AudioState.playing,
                          ),
                        );
                    return;
                  }
                  if (isDownloaded) {
                    if (audioPath != null) {
                      ref.read(cdNotifierProvider.notifier).playOffline(
                            audioPath!,
                            "${widget.title} ${widget.index}",
                            widget.courseModel,
                            widget.audioId,
                          );
                      return;
                    } else {
                      toast("try again.", ToastType.error);
                      return;
                    }
                  }

                  setState(() {
                    isLoading = true;
                  });
                  String? url = await ref
                      .read(cdNotifierProvider.notifier)
                      .loadFileOnline(widget.audioId);
                  if (url != null) {
                    if (mounted) {
                      await ref.read(cdNotifierProvider.notifier).playOnline(
                            url,
                            "${widget.title} ${widget.index}",
                            widget.courseModel,
                            widget.audioId,
                          );
                    }
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    print("url is null");
                    if (mounted) {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      width: 45,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: whiteColor,
                              ),
                            )
                          : myState.isIdle() || myState.isPlaused()
                              ? const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 35,
                                  color: whiteColor,
                                )
                              : const Icon(
                                  Icons.pause_rounded,
                                  size: 35,
                                  color: whiteColor,
                                ),
                    ),
                    !isDownloaded || downLoadProg?.filePath == audioPath
                        ? Positioned(
                            bottom: 0,
                            right: 0,
                            child: DownloadIcon(
                              onTap: () async {
                                if (downLoadProg?.filePath == audioPath) {
                                  downLoadProg!.cancelToken.cancel();
                                  cancelToken = CancelToken();
                                  return;
                                }
                                isDownloading = true;
                                File? file = await ref
                                    .read(cdNotifierProvider.notifier)
                                    .downloadFile(
                                      widget.audioId,
                                      "${widget.courseModel.ustaz},${widget.title} ${widget.index}.mp3",
                                      'Audio',
                                      cancelToken,
                                      context,
                                    );
                                isDownloading = false;
                                if (file != null) {
                                  isDownloaded = await checkFile();
                                  if (mounted) {
                                    setState(() {});
                                  }
                                }
                              },
                              isLoading: isDownloading ||
                                  downLoadProg?.filePath == audioPath &&
                                      downLoadProg != null &&
                                      downLoadProg.progress < 100,
                              progress: downLoadProg != null
                                  ? downLoadProg.progress
                                  : 0,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              title: Row(
                children: [
                  if (!widget.isFromPDF)
                    Expanded(
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Expanded(child: Text("${widget.index}"))
                ],
              ),
              subtitle: Text(
                widget.courseModel.ustaz,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        });
  }
}
