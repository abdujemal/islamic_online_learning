import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_model.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';

class AudioItem extends ConsumerStatefulWidget {
  final String audioId;
  final String title;
  final CourseModel courseModel;
  const AudioItem(this.audioId, this.title, this.courseModel, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AudioItemState();
}

class _AudioItemState extends ConsumerState<AudioItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AudioState myState = ref.watch(checkAudioModelProvider
        .call("${widget.title} ${widget.courseModel.ustaz}"));
    return Container(
      decoration: BoxDecoration(
        color: myState.isPlaying() || myState.isPlaused() ? primaryColor : null,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: ListTile(
        trailing: myState.isPlaying() || myState.isPlaused()
            ? IconButton(
                onPressed: () {
                  ref.read(audioProvider).stop();
                  ref
                      .read(currentAudioProvider.notifier)
                      .update((state) => null);
                  ref
                    .read(currentCourseProvider.notifier)
                    .update((state) => null);
                },
                icon: const Icon(Icons.close),
              )
            : null,
        leading: IconButton(
          onPressed: () async {
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
            try {
              print(widget.audioId);
              String? url = await getUrlOfAudio(widget.audioId);
              setState(() {
                isLoading = true;
              });
              if (url != null) {
                await ref.read(audioProvider).play(UrlSource(url));
                ref.read(currentAudioProvider.notifier).update(
                      (state) => AudioModel(
                        title: widget.title,
                        ustaz: widget.courseModel.ustaz,
                        min: 0,
                        audioState: AudioState.playing,
                      ),
                    );

                ref
                    .read(currentCourseProvider.notifier)
                    .update((state) => widget.courseModel);

                setState(() {
                  isLoading = false;
                });
              } else {
                print("url is null");
                setState(() {
                  isLoading = false;
                });
              }
            } catch (e) {
              setState(() {
                isLoading = false;
              });
              toast(e.toString(), ToastType.error);
            }
          },
          icon: isLoading
              ? const CircularProgressIndicator()
              : myState.isIdle() || myState.isPlaused()
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.pause),
        ),
        title: Text(
          widget.title,
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
