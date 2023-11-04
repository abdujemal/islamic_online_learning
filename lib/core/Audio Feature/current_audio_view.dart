import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_model.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/pages/course_detail.dart';

class CurrentAudioView extends ConsumerStatefulWidget {
  final AudioModel audioModel;
  const CurrentAudioView(this.audioModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CurrentAudioViewState();
}

class _CurrentAudioViewState extends ConsumerState<CurrentAudioView> {
  @override
  Widget build(BuildContext context) {
    final currentAudio = widget.audioModel;

    final currentCourse = ref.watch(currentCourseProvider);

    return InkWell(
      onTap: () {
        if (currentCourse != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => CourseDetail(
                courseModel: currentCourse,
              ),
            ),
          );
        }
      },
      child: Ink(
          color: primaryColor,
          child: Row(
            children: [
              IconButton(
                icon: currentAudio.audioState.isPlaused()
                    ? const Icon(Icons.play_arrow)
                    : const Icon(Icons.pause),
                onPressed: () {
                  ref.read(currentAudioProvider.notifier).update(
                        (state) => state!.copyWith(
                          audioState: currentAudio.audioState.isPlaused()
                              ? AudioState.playing
                              : AudioState.paused,
                        ),
                      );
                  if (currentAudio.audioState.isPlaused()) {
                    ref.read(audioProvider).resume();
                  } else {
                    ref.read(audioProvider).pause();
                  }
                },
              ),
              Expanded(
                child: Text(
                  currentAudio.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  currentAudio.ustaz,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: DefaultTextStyle.of(context)
                          .style
                          .color!
                          .withOpacity(0.7)),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(audioProvider).stop();
                  ref
                      .read(currentAudioProvider.notifier)
                      .update((state) => null);
                  // ref.read(endListnersProvider);
                  ref
                      .read(audioPlayerPositionProvider.notifier)
                      .update((state) => Duration.zero);
                  ref
                      .read(audioPlayerDurationProvider.notifier)
                      .update((state) => Duration.zero);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          )),
    );
  }
}
