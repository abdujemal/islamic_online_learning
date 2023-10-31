import 'dart:io';

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

  double getSize(File file) {
    int fileSizeInBytes = file.lengthSync();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    return fileSizeInMB;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (ctx) => DeleteConfirmation(
              title: "ሁሉ",
              action: () async {
                await pdfsNotifier.deleteAllFiles();
                pdfsNotifier.getPdfs();
              },
            ),
          );
        },
        child: const Icon(
          Icons.delete,
          color: whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ref.watch(pdfsNotifierProvider).map(
              initial: (_) => const SizedBox(),
              loading: (_) => ListView.builder(
                itemCount: 10,
                itemBuilder: (index, context) => const CourseShimmer(),
              ),
              loaded: (_) => RefreshIndicator(
                onRefresh: () async {
                  await ref.read(pdfsNotifierProvider.notifier).getPdfs();
                },
                color: primaryColor,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 0),
                  itemCount: _.pdfs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(
                        Icons.menu_book_sharp,
                        size: 30,
                      ),
                      title: Text(getTitle(_.pdfs[index].path)),
                      subtitle: Text("${getSize(_.pdfs[index]).round()} mb"),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await _.pdfs[index].delete();
                          pdfsNotifier.getPdfs();
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
