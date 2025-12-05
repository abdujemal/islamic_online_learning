import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GroupChatPage extends ConsumerStatefulWidget {
  const GroupChatPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends ConsumerState<GroupChatPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Group Chat"),
        ),
      ),
    );
  }
}
