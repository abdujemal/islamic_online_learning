import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/current_audio_view.dart';
import 'package:islamic_online_learning/core/database_helper.dart';
import 'package:islamic_online_learning/features/main/presentation/pages/filtered_courses.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/Audio Feature/playlist_helper.dart';

class Contents extends ConsumerStatefulWidget {
  const Contents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContentsState();
}

class _ContentsState extends ConsumerState<Contents> {
  List<String> contents = [];

  bool isLoading = false;

  bool showTopAudio = false;
  @override
  void initState() {
    super.initState();

    isLoading = true;
    setState(() {});
    DatabaseHelper().getContent().then((value) {
      contents = value;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = PlaylistHelper.audioPlayer;

    return StreamBuilder(
      stream: myAudioStream(audioPlayer),
      builder: (context, snap) {
        final state = snap.data?.sequenceState;
        final processState = snap.data?.processingState;

        if (state?.sequence.isEmpty ?? true) {
          showTopAudio = false;
        }

        MediaItem? metaData = state?.currentSource?.tag;

        if (metaData != null) {
          showTopAudio = true;
        }

        if (processState == ProcessingState.idle) {
          showTopAudio = false;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("ማውጫ"),
            bottom: PreferredSize(
              preferredSize: Size(
                MediaQuery.of(context).size.width,
                showTopAudio ? 40 : 0,
              ),
              child: showTopAudio
                  ? CurrentAudioView(metaData as MediaItem)
                  : const SizedBox(),
            ),
          ),
          body: SafeArea(
            child: isLoading
                ? ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Shimmer.fromColors(
                        baseColor: Theme.of(context)
                            .chipTheme
                            .backgroundColor!
                            .withAlpha(150),
                        highlightColor:
                            Theme.of(context).chipTheme.backgroundColor!,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context)
                                      .chipTheme
                                      .backgroundColor!,
                                ),
                              ),
                            ),
                            child: ListTile(
                              leading: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Container(
                                height: 10,
                                width: 150,
                                margin: const EdgeInsets.only(right: 30),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: contents.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        leading: Text("${index + 1}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => FilteredCourses(
                                "title",
                                contents[index],
                              ),
                            ),
                          );
                        },
                        trailing: const Icon(Icons.arrow_outward),
                        title: Text(
                          contents[index],
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
