import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FAQ extends ConsumerStatefulWidget {
  const FAQ({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FAQState();
}

class _FAQState extends ConsumerState<FAQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ስለ አፑ የተጠየቁ ጥያቄዎች"),
      ),
    );
  }
}
