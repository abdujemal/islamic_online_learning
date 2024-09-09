import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:islamic_online_learning/core/constants.dart';
import 'package:path_provider/path_provider.dart';

class NoteHiveHelper {
  static NoteHiveHelper? _databaseHelper;
  static BoxCollection? _database;

  NoteHiveHelper._createInstance();
  factory NoteHiveHelper() {
    _databaseHelper ??= NoteHiveHelper._createInstance();
    return _databaseHelper!;
  }

  Future<BoxCollection> initializeDatabase() async {
    Directory directory = await getApplicationSupportDirectory();
    String path = '${directory.path}$hivePath';

    var notesDatabase = await BoxCollection.open(
      "MyNoteBook",
      {'Notes'},
      path: path,
    );

    if (kDebugMode) {
      print("db is ready");
    }
    return notesDatabase;
  }

  Future<BoxCollection?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  addNote(int page, int courseId, String note) async {
    final noteBox = await (await database)!.openBox('Notes');

    final String id = "${Random().nextInt(100000)}";
    noteBox.put(id, {
      'id': id,
      'page': page,
      "courseId": courseId,
      'note': note,
    });
  }

  Future<List<Map>> getAllNoteOfAPage(int page, int courseID) async {
    final noteBox = await (await database)!.openBox('Notes');

    final allNotes = await noteBox.getAllValues();
    List<Map> filteredNotes = [];

    allNotes.forEach((k, v) {
      if (v['page'] == page && v['courseId'] == courseID) {
        filteredNotes.add(v);
      }
    });

    return filteredNotes;
  }

  Future<List<Map>> getAllNoteOfACourse(int courseId) async {
    final noteBox = await (await database)!.openBox('Notes');

    final allNotes = await noteBox.getAllValues();
    List<Map> filteredNotes = [];

    allNotes.forEach((k, v) {
      if (v['courseId'] == courseId) {
        filteredNotes.add(v);
      }
    });

    return filteredNotes;
  }

  deleteNote(String id) async {
    final noteBox = await (await database)!.openBox('Notes');

    noteBox.delete(id);
  }

  closeDb() async {
    _database!.close();
  }
}

final pdfPageProvider = StateProvider<int>((ref) {
  return 0;
});
