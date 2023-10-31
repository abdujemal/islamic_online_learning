import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutUs extends ConsumerStatefulWidget {
  const AboutUs({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutUsState();
}

class _AboutUsState extends ConsumerState<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ስለ እኛ"),
      ),
    );
  }
}
