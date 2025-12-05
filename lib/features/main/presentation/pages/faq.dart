import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/Audio%20Feature/audio_providers.dart';
import 'package:islamic_online_learning/features/main/presentation/state/faq_list_notifier.dart';
import 'package:islamic_online_learning/features/main/presentation/state/provider.dart';
import 'package:islamic_online_learning/features/main/presentation/widgets/faq_item.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/Audio Feature/current_audio_view.dart';
import '../../../../core/Audio Feature/playlist_helper.dart';
import '../../../../core/constants.dart';

class FAQ extends ConsumerStatefulWidget {
  const FAQ({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FAQState();
}

class _FAQState extends ConsumerState<FAQ> {
  late FaqListNotifier faqListNotifier;

  int countIteration = 0;

  bool showTopAudio = false;

  @override
  initState() {
    super.initState();
    faqListNotifier = ref.read(faqNotifierProvider.notifier);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      faqListNotifier.getFAQs();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        // final mainState = ref.read(mainNotifierProvider.notifier);
        // final ustazState = ref.read(ustazNotifierProvider.notifier);

        // faqListNotifier.addListener((state) {
        //   state.mapOrNull(loaded: (_) {
        //     if (mounted) {
        //       showDialog(
        //         context: context,
        //         builder: (ctx) => UpdateAllCourses(_.faqs),
        //       );
        //     }
        //   });
        // });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final currentAudio = ref.watch(currentAudioProvider);
    final audioPlayer = PlaylistHelper.audioPlayer;
    return StreamBuilder(
        stream: myAudioStream(audioPlayer),
        builder: (context, snap) {
          final state = snap.data?.sequenceState;
          final process = snap.data?.processingState;

          if (state?.sequence.isEmpty ?? true) {
            showTopAudio = false;
          }
          MediaItem? metaData = state?.currentSource?.tag;

          if (metaData != null) {
            showTopAudio = true;
          }
          if (process == ProcessingState.idle) {
            showTopAudio = false;
          }
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("ስለ መተግበሪያው የተጠየቁ ጥያቄዎች"),
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
                child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Builder(
                  builder: (context) {
                  final state = ref.watch(faqNotifierProvider);
                  if (state.isLoading) {
                    return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Theme.of(context)
                        .chipTheme
                        .backgroundColor!
                        .withAlpha(150),
                      highlightColor:
                        Theme.of(context).chipTheme.backgroundColor!,
                      child: Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Container(
                            height: 10,
                            width: 150,
                            decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          ),
                        ),
                        ],
                      ),
                      ),
                    ),
                    );
                  } else if (!state.isLoading && state.faqs.isNotEmpty) {
                    return RefreshIndicator(
                    onRefresh: () async {
                      await ref.read(faqNotifierProvider.notifier).getFAQs();
                    },
                    color: primaryColor,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 0),
                      itemCount: state.faqs.length,
                      itemBuilder: (context, index) {
                      return FaqItem(faqModel: state.faqs[index]);
                      },
                    ),
                    );
                  } else if (!state.isLoading && state.faqs.isEmpty) {
                    return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      const Text("እባክዎ ኢንተርኔት አብርተው ድጋሚ ይሞክሩ።"),
                      IconButton(
                        onPressed: () async {
                        await ref
                          .read(faqNotifierProvider.notifier)
                          .getFAQs();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                      )
                      ],
                    ),
                    );
                  } else if (!state.isLoading && state.error != null) {
                    return Center(
                    child: Text(state.error!),
                    );
                  } else {
                    return const SizedBox();
                  }
                  },
                ),
                ),
              ),
            ),
          );
        });
  }
}
