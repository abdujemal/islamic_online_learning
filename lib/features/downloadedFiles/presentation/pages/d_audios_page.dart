import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          await audiosNotifier.deleteAllFiles();
          audiosNotifier.getAudios();
        },
        child: const Icon(Icons.delete),
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
                      leading: const Icon(Icons.music_note),
                      title: Text(getTitle(_.audios[index].path)),
                      subtitle: Text(getUstaz(_.audios[index].path)),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
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
                      icon: const Icon(Icons.refresh),
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
