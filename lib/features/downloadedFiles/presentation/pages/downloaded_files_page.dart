import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/pages/d_audios_page.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/pages/d_images_page.dart';
import 'package:islamic_online_learning/features/downloadedFiles/presentation/pages/d_pdfs_page.dart';

class DownloadedFilesPage extends ConsumerStatefulWidget {
  const DownloadedFilesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DownloadedFilesPageState();
}

class _DownloadedFilesPageState extends ConsumerState<DownloadedFilesPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ዳውንሎድ የተደረጉ"),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              child: Text(
                'ፒዲኡፎች',
                style: TextStyle(color: primaryColor),
              ),
            ),
            Tab(
              child: Text(
                'ድምጾች',
                style: TextStyle(color: primaryColor),
              ),
            ),
            Tab(
              child: Text(
                'ምስሎች',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          DPdfsPage(),
          DAudiosPage(),
          DImagesPage(),
        ],
      ),
    );
  }
}
