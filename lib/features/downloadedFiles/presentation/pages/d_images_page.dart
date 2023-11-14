
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/images_notifier.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/provider.dart';

import '../../../../core/constants.dart';
import '../../../courseDetail/presentation/widgets/delete_confirmation.dart';
import '../../../main/presentation/widgets/course_shimmer.dart';

class DImagesPage extends ConsumerStatefulWidget {
  const DImagesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DImagesPageState();
}

class _DImagesPageState extends ConsumerState<DImagesPage> {
  late ImagesNotifier imageNotifier;

  @override
  void initState() {
    super.initState();

    imageNotifier = ref.read(imagesNotifierProvider.notifier);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      imageNotifier.getImages();
    });
  }

  String getTitle(String path) {
    final fldrs = path.split("/");
    return fldrs[fldrs.length - 1].split(",").last;
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
                await imageNotifier.deleteAllFiles();
                imageNotifier.getImages();
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
        child: ref.watch(imagesNotifierProvider).map(
              initial: (_) => const SizedBox(),
              loading: (_) => ListView.builder(
                itemCount: 10,
                itemBuilder: (index, context) => const CourseShimmer(),
              ),
              loaded: (_) => RefreshIndicator(
                onRefresh: () async {
                  await ref.read(imagesNotifierProvider.notifier).getImages();
                },
                color: primaryColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: _.images.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.file(
                        _.images[index],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(getTitle(_.images[index].path)),
                      subtitle: Text(formatFileSize(_.images[index].lengthSync())),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_rounded,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await _.images[index].delete();
                          imageNotifier.getImages();
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
                        await ref.read(pdfsNotifierProvider.notifier).getPdfs();
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
