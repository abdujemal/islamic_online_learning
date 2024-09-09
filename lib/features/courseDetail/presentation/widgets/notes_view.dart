import 'package:flutter/material.dart';
import 'package:islamic_online_learning/core/note_helper.dart';

class NotesView extends StatefulWidget {
  final int courseId;
  const NotesView({
    super.key,
    required this.courseId,
  });

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  List<Map> notes = [];
  int? currentPage;

  @override
  void initState() {
    super.initState();
    NoteHiveHelper().getAllNoteOfACourse(widget.courseId).then((e) {
      notes = e;
      notes.sort((a, b) => (a['page'] as int).compareTo(b['page'] as int));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "ማስታወሻ",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 19,
              ),
              Expanded(
                child: notes.isEmpty
                    ? const Center(
                        child: Text("ምንም የለም"),
                      )
                    : ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0 ||
                                  notes[index]['page'] !=
                                      notes[index - 1]['page'])
                                Align(
                                  alignment: Alignment.center,
                                  child: Chip(
                                      side: BorderSide.none,
                                      label: Text(
                                          "ገፅ: ${notes[index]['page'] + 1}")),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          "${index + 1}. ${notes[index]['note']}"),
                                    ),
                                    if (notes[index]['id'] != null)
                                      GestureDetector(
                                        onTap: () {
                                          NoteHiveHelper()
                                              .deleteNote(notes[index]['id']);
                                          notes.removeWhere((e) =>
                                              e['id'] == notes[index]['id']);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
