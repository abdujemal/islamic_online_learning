import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:islamic_online_learning/core/note_helper.dart';

import '../../../../core/constants.dart';

class AddNote extends StatefulWidget {
  final int page;
  final int courseId;
  final WidgetRef ref;
  const AddNote({
    super.key,
    required this.page,
    required this.courseId,
    required this.ref,
  });

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController noteTc = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "ማስታወሻ በ${widget.page + 1}ኛው ገፅ ላይ",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                TextField(
                  controller: noteTc,
                  maxLines: null,
                  minLines: 3,
                  decoration: const InputDecoration(
                    label: Text("ማስታወሻዎን እዚህ ላይ ያስፍሩ"),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    loading = true;
                    setState(() {});
                    widget.ref.read(pdfPageProvider.notifier).update((i) => 0);
                    widget.ref
                        .read(pdfPageProvider.notifier)
                        .update((i) => widget.page);
                    await NoteHiveHelper().addNote(
                      widget.page,
                      widget.courseId,
                      noteTc.text,
                    );
                    loading = false;
                    setState(() {});
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Card(
                    color: primaryColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            Icon(
                              Icons.save,
                              color: whiteColor,
                            ),
                            Expanded(
                              child: Text(
                                "አስቀምጥ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
