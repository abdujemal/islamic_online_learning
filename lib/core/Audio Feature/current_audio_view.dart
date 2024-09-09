import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/playlist_helper.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../features/courseDetail/presentation/pages/course_detail.dart';
import '../../features/main/presentation/state/provider.dart';

class CurrentAudioView extends ConsumerStatefulWidget {
  final MediaItem mediaItem;
  final String? keey;
  final String? val;
  const CurrentAudioView(this.mediaItem, {
     this.keey,
     this.val,
    super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentAudioViewState();
}

class _CurrentAudioViewState extends ConsumerState<CurrentAudioView> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => CourseDetail(
              keey: widget.keey,
              val: widget.val,
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
                stream: PlaylistHelper.audioPlayer.playerStateStream,
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
                      if (PlaylistHelper.audioPlayer.playing) {
                        PlaylistHelper.audioPlayer.pause();
                      } else {
                        PlaylistHelper.audioPlayer.play();
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
                    int id = int.parse(widget.mediaItem.title
                            .split(" ")
                            .last
                            .replaceAll('.mp3', 'replace')) -
                        1;
                    print("Audio Id $id");
                    await ref.read(mainNotifierProvider.notifier).saveCourse(
                          CourseModel.fromMap(
                            widget.mediaItem.extras as Map,
                            widget.mediaItem.extras?["courseId"],
                          ).copyWith(
                            isStarted: 1,
                            pausedAtAudioNum: id,
                            pausedAtAudioSec:
                                PlaylistHelper.audioPlayer.position.inSeconds,
                            lastViewed: DateTime.now().toString(),
                          ),
                          null,
                          context,
                          showMsg: false,
                        );
                  }
                  // }
                  PlaylistHelper.audioPlayer.stop();
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
