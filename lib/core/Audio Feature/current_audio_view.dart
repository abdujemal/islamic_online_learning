import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../features/courseDetail/presentation/pages/course_detail.dart';
import '../../features/main/presentation/state/provider.dart';

class CurrentAudioView extends ConsumerStatefulWidget {
  final MediaItem mediaItem;
  const CurrentAudioView(this.mediaItem, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentAudioViewState();
}

class _CurrentAudioViewState extends ConsumerState<CurrentAudioView> {
  @override
  Widget build(BuildContext context) {
    final audioPlayer = ref.watch(audioProvider);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => CourseDetail(
              cm: CourseModel.fromMap(
                widget.mediaItem.extras as Map,
                widget.mediaItem.extras!["courseId"],
              ),
            ),
          ),
        );
      },
      child: Ink(
        color: primaryColor,
        child: SizedBox(
          height: 40,
          child: Row(
            children: [
              StreamBuilder(
                stream: audioPlayer.playerStateStream,
                builder: (context, snap) {
                  if (snap.data == null) {
                    return const SizedBox();
                  }
                  return IconButton(
                    icon: snap.data!.playing
                        ? const Icon(
                            Icons.pause_rounded,
                            color: whiteColor,
                          )
                        : const Icon(
                            Icons.play_arrow_rounded,
                            color: whiteColor,
                          ),
                    onPressed: () {
                      if (ref.read(audioProvider).playing) {
                        ref.read(audioProvider).pause();
                      } else {
                        ref.read(audioProvider).play();
                      }
                    },
                  );
                },
              ),
              Expanded(
                child: TextScroll(
                  widget.mediaItem.title,
                  style: const TextStyle(
                    color: whiteColor,
                  ),
                  velocity: const Velocity(
                    pixelsPerSecond: Offset(30, 0),
                  ),
                  pauseBetween: const Duration(seconds: 1),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "በ${widget.mediaItem.artist!}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (widget.mediaItem.extras?["isFinished"] == 0) {
                    // if (!audioPlayer.hasNext) {
                    //   await showDialog(
                    //     context: context,
                    //     barrierDismissible: false,
                    //     builder: (ctx) => FinishConfirmation(
                    //       title: widget.mediaItem.title
                    //           .split(" ")
                    //           .sublist(
                    //             0,
                    //             widget.mediaItem.title.split(" ").length - 2,
                    //           )
                    //           .join(" "),
                    //       onConfirm: () {
                    //         if (mounted) {
                    //           ref
                    //               .read(mainNotifierProvider.notifier)
                    //               .saveCourse(
                    //                 CourseModel.fromMap(
                    //                   widget.mediaItem.extras as Map,
                    //                   widget.mediaItem.extras?["courseId"],
                    //                 ).copyWith(
                    //                   isStarted: 1,
                    //                   isFinished: 1,
                    //                   pausedAtAudioNum:
                    //                       audioPlayer.currentIndex,
                    //                   pausedAtAudioSec:
                    //                       audioPlayer.position.inSeconds,
                    //                   lastViewed: DateTime.now().toString(),
                    //                 ),
                    //                 null,
                    //                 context,
                    //                 showMsg: false,
                    //               );
                    //         }
                    //         Navigator.pop(context);
                    //       },
                    //       onDenied: () {
                    //         ref.read(mainNotifierProvider.notifier).saveCourse(
                    //               CourseModel.fromMap(
                    //                 widget.mediaItem.extras as Map,
                    //                 widget.mediaItem.extras?["courseId"],
                    //               ).copyWith(
                    //                 isStarted: 1,
                    //                 pausedAtAudioNum: audioPlayer.currentIndex,
                    //                 pausedAtAudioSec:
                    //                     audioPlayer.position.inSeconds,
                    //                 lastViewed: DateTime.now().toString(),
                    //               ),
                    //               null,
                    //               context,
                    //               showMsg: false,
                    //             );
                    //         Navigator.pop(context);
                    //       },
                    //     ),
                    //   );
                    // } else {
                    await ref.read(mainNotifierProvider.notifier).saveCourse(
                          CourseModel.fromMap(
                            widget.mediaItem.extras as Map,
                            widget.mediaItem.extras?["courseId"],
                          ).copyWith(
                            isStarted: 1,
                            pausedAtAudioNum: audioPlayer.currentIndex,
                            pausedAtAudioSec: audioPlayer.position.inSeconds,
                            lastViewed: DateTime.now().toString(),
                          ),
                          null,
                          context,
                          showMsg: false,
                        );
                  }
                  // }
                  ref.read(audioProvider).stop();
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
