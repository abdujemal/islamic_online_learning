// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      content: Text("${widget.title}ን ማጥፋት ይፈልጋሉን?"),
      alignment: Alignment.center,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "አይ",
          ),
        ),
        TextButton(
          onPressed: () {
            widget.action();
            Navigator.pop(context);
          },
          child: const Text(
            "አዎን",
          ),
        ),
      ],
    );
  }
}
