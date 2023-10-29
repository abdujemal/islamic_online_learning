import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_model.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/stateNotifier/providers.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/download_icon.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/course_detail_data_src.dart';

class AudioItem extends ConsumerStatefulWidget {
  final String audioId;
  final String title;
  final CourseModel courseModel;
  final bool isFromPDF;
  const AudioItem(this.audioId, this.title, this.courseModel, this.isFromPDF,
      {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AudioItemState();
}

class _AudioItemState extends ConsumerState<AudioItem> {
  bool isLoading = false;
  bool isDownloaded = false;
  bool isDownloading = false;

  String? audioPath;

  @override
  void initState() {
    super.initState();

    // Future.delayed(const Duration(milliseconds: 500)).then((value) {
    //   checkFile();
    // });

    if (mounted) {
      checkFile();
    }

    getPath('Audio', "${widget.courseModel.ustaz},${widget.title}.mp3")
        .then((value) {
      audioPath = value;
      setState(() {});
    });
  }

  checkFile() {
    if (mounted) {
      ref
          .read(cdNotifierProvider.notifier)
          .isDownloaded(
              "${widget.courseModel.ustaz},${widget.title}.mp3", "Audio")
          .then((value) {
        setState(() {
          setState(() {
            isDownloaded = value;
          });
        });
      });
    }
  }

  Future<String> getPath(String folderName, String fileName) async {
    Directory dir = await getApplicationSupportDirectory();

    return "${dir.path}/$folderName/$fileName";
  }

  @override
  Widget build(BuildContext context) {
    AudioState myState = ref.watch(checkAudioModelProvider
        .call("${widget.courseModel.ustaz},${widget.title}"));

    final downLoadProg =
        ref.watch(downloadProgressCheckernProvider.call(audioPath));

    return Container(
      decoration: BoxDecoration(
        color: myState.isPlaying() || myState.isPlaused() ? Colors.grey : null,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: ListTile(
        trailing: isDownloaded
            ? IconButton(
                onPressed: () async {
                  await ref.read(cdNotifierProvider.notifier).deleteFile(
                      '${widget.courseModel.ustaz},${widget.title}.mp3',
                      "Audio");

                  checkFile();
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              )
            : null,
        leading: GestureDetector(
          onTap: () async {
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
              ref.read(audioProvider).resume();
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
                      widget.title,
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
                      widget.title,
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
                            Icons.play_arrow,
                            size: 35,
                            color: whiteColor,
                          )
                        : const Icon(
                            Icons.pause,
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
                          isDownloading = true;
                          File? file = await ref
                              .read(cdNotifierProvider.notifier)
                              .downloadFile(
                                  widget.audioId,
                                  "${widget.courseModel.ustaz},${widget.title}.mp3",
                                  'Audio');
                          isDownloading = false;
                          if (file != null) {
                            checkFile();
                          }
                        },
                        isLoading: isDownloading ||
                            downLoadProg?.filePath == audioPath &&
                                downLoadProg != null &&
                                downLoadProg.progress < 100,
                        progress:
                            downLoadProg != null ? downLoadProg.progress : 0,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
        title: Text(
          widget.isFromPDF ? widget.title.split(" ").last : widget.title,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          widget.courseModel.ustaz,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
