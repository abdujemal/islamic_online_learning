// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/constants.dart';

class DeleteConfirmation extends ConsumerStatefulWidget {
  final String title;
  final VoidCallback action;
  const DeleteConfirmation({
    super.key,
    required this.title,
    required this.action,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeleteConfirmationState();
}

class _DeleteConfirmationState extends ConsumerState<DeleteConfirmation> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("${widget.title}ን ማጥፋት ይፈልጋሉን?"),
      titleTextStyle: TextStyle(fontSize: 19),
      alignment: Alignment.center,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "አይ",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.action();
            Navigator.pop(context);
          },
          child: const Text(
            "አዎን",
            style: TextStyle(
              color: primaryColor,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
