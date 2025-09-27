import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/pdfs_notifier.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/stateNotifier/provider.dart';

import '../../../../core/constants.dart';
import '../../../courseDetail/presentation/widgets/delete_confirmation.dart';
import '../../../main/presentation/widgets/course_shimmer.dart';

class DPdfsPage extends ConsumerStatefulWidget {
  const DPdfsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DPdfsPageState();
}

class _DPdfsPageState extends ConsumerState<DPdfsPage> {
  late PdfsNotifier pdfsNotifier;

  @override
  void initState() {
    super.initState();

    pdfsNotifier = ref.read(pdfsNotifierProvider.notifier);

    Future.delayed(const Duration(seconds: 1)).then((value) {
      pdfsNotifier.getPdfs();
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
                await pdfsNotifier.deleteAllFiles(context);
                pdfsNotifier.getPdfs();
              },
            ),
          );
        },
        child: const Icon(
          Icons.delete_rounded,
          color: whiteColor,
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Builder(builder: (context) {
              final state = ref.watch(pdfsNotifierProvider);
              if (state.isLoading) {
                return ListView.builder(
                  itemCount: 10,
                  itemBuilder: (index, context) => const CourseShimmer(),
                );
              } else if (!state.isLoading && state.error != null) {
                return Center(
                  child: Text(state.error!),
                );
              } else if (!state.isLoading && state.pdf.isNotEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(pdfsNotifierProvider.notifier).getPdfs();
                  },
                  color: primaryColor,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: state.pdf.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.menu_book_rounded,
                          size: 30,
                        ),
                        title: Text(getTitle(state.pdf[index].path)),
                        subtitle:
                            Text(formatFileSize(state.pdf[index].lengthSync())),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await state.pdf[index].delete();
                            pdfsNotifier.getPdfs();
                          },
                        ),
                      );
                    },
                  ),
                );
              } else if (!state.isLoading && state.pdf.isEmpty) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("ምንም የለም"),
                      IconButton(
                        onPressed: () async {
                          await ref
                              .read(pdfsNotifierProvider.notifier)
                              .getPdfs();
                        },
                        icon: const Icon(Icons.refresh_rounded),
                      )
                    ],
                  ),
                );
              } else {
                return SizedBox();
              }
            })

            // ref.watch(pdfsNotifierProvider).map(
            //       initial: (_) => const SizedBox(),
            // loading: (_) => ListView.builder(
            //   itemCount: 10,
            //   itemBuilder: (index, context) => const CourseShimmer(),
            // ),
            // loaded: (_) => RefreshIndicator(
            //   onRefresh: () async {
            //     await ref.read(pdfsNotifierProvider.notifier).getPdfs();
            //   },
            //   color: primaryColor,
            //   child: ListView.builder(
            //     physics: const AlwaysScrollableScrollPhysics(),
            //     padding: const EdgeInsets.only(bottom: 100),
            //     itemCount: state.pdf.length,
            //     itemBuilder: (context, index) {
            //       return ListTile(
            //         leading: const Icon(
            //           Icons.menu_book_rounded,
            //           size: 30,
            //         ),
            //         title: Text(getTitle(_.pdfs[index].path)),
            //         subtitle:
            //             Text(formatFileSize(_.pdfs[index].lengthSync())),
            //         trailing: IconButton(
            //           icon: const Icon(
            //             Icons.delete_rounded,
            //             color: Colors.red,
            //           ),
            //           onPressed: () async {
            //             await _.pdfs[index].delete();
            //             pdfsNotifier.getPdfs();
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // empty: (_) => Center(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Text("ምንም የለም"),
            //       IconButton(
            //         onPressed: () async {
            //           await ref.read(pdfsNotifierProvider.notifier).getPdfs();
            //         },
            //         icon: const Icon(Icons.refresh_rounded),
            //       )
            //     ],
            //   ),
            // ),
            // error: (_) => Center(
            //   child: Text(_.error.messege),
            // ),
            //     ),

            ),
      ),
    );
  }
}
