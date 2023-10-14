// ignore_for_file: must_call_super

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Download extends ConsumerStatefulWidget {
  const Download({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DownloadState();
}

class _DownloadState extends ConsumerState<Download>
    with AutomaticKeepAliveClientMixin<Download> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Downloads"),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
