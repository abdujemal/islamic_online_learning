import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DownloadedFilesPage extends ConsumerStatefulWidget {
  const DownloadedFilesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DownloadedFilesPageState();
}

class _DownloadedFilesPageState extends ConsumerState<DownloadedFilesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ዳውንሎድ የተደረጉ"),
      ),
    );
  }
}
