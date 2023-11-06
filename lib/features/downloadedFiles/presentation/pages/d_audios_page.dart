import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/courseDetail/presentation/widgets/delete_confirmation.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/audios_notifier.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/provider.dart';

import '../../../main/presentation/widgets/course_shimmer.dart';

class DAudiosPage extends ConsumerStatefulWidget {
  const DAudiosPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DAudiosPageState();
}

class _DAudiosPageState extends ConsumerState<DAudiosPage> {
  late AudiosNotifier audiosNotifier;

  @override
  void initState() {
    super.initState();

    audiosNotifier = ref.read(audiosNotifierProvider.notifier);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      audiosNotifier.getAudios();
    });
  }

  String getTitle(String path) {
    final fldrs = path.split("/");
    return fldrs[fldrs.length - 1].split(",").last;
  }

  String getUstaz(String path) {
    final fldrs = path.split("/");
    return fldrs[fldrs.length - 1].split(",")[0];
  }

  double getSize(File file) {
    int fileSizeInBytes = file.lengthSync();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    return fileSizeInMB;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   bottom: PreferredSize(
      //     preferredSize: Size(
      //       MediaQuery.of(context).size.width,
      //       currentAudio != null ? 40 : 0,
      //     ),
      //     child: currentAudio != null
      //         ? CurrentAudioView(currentAudio)
      //         : const SizedBox(),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (ctx) => DeleteConfirmation(
              title: "ሁሉ",
              action: () async {
                await audiosNotifier.deleteAllFiles();
                audiosNotifier.getAudios();
              },
            ),
          );
        },
        child: const Icon(
          Icons.delete_rounded,
          color: whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ref.watch(audiosNotifierProvider).map(
              initial: (_) => const SizedBox(),
              loading: (_) => ListView.builder(
                itemCount: 10,
                itemBuilder: (index, context) => const CourseShimmer(),
              ),
              loaded: (_) => RefreshIndicator(
                onRefresh: () async {
                  await ref.read(audiosNotifierProvider.notifier).getAudios();
                },
                color: primaryColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 60),
                  itemCount: _.audios.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: SizedBox(
                        height: 60,
                        width: 60,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.music_note_rounded,
                              size: 30,
                            ),
                            Text(
                              "${getSize(_.audios[index]).round()} mb",
                              style: const TextStyle(fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      title: Text(getTitle(_.audios[index].path)),
                      subtitle: Text(getUstaz(_.audios[index].path)),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await _.audios[index].delete();
                          audiosNotifier.getAudios();
                        },
                      ),
                    );
                  },
                ),
              ),
              empty: (_) => Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("ምንም የለም"),
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(audiosNotifierProvider.notifier)
                            .getAudios();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                    )
                  ],
                ),
              ),
              error: (_) => Center(
                child: Text(_.error.messege),
              ),
            ),
      ),
    );
  }
}
