import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:islamic_online_learning/features/main/data/main_data_src.dart';
import 'package:islamic_online_learning/features/main/data/model/course_model.dart';
import 'package:islamic_online_learning/features/main/data/model/faq_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../features/main/presentation/pages/faq.dart';
import 'constants.dart';

// import 'constants.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  closeDb() async {
    await _database!.close();
  }

  Future<int?> getFileSize(String audioUrl) async {
    final request = await HttpClient().headUrl(Uri.parse(audioUrl));
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      final contentLength = response.contentLength;
      return contentLength;
    }
    throw Exception('Failed to get audio file size');
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}$dbPath';

    var notesDatabase = await openDatabase(
      path,
      version: 1,
      // onCreate: _createDb,
    );
    if (kDebugMode) {
      print("db is ready");
    }
    return notesDatabase;
  }

  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  //creating database
  // void _createDb(Database db, int newVersion) async {
  //   await db.execute('CREATE TABLE ${DatabaseConst.savedCourses}('
  //       'id INTEGER PRIMARY KEY AUTOINCREMENT,'
  //       'courseId TEXT,'
  //       'author TEXT,'
  //       'category TEXT,'
  //       'courseIds TEXT,'
  //       'noOfRecord INTEGER,'
  //       'pdfId TEXT,'
  //       'title TEXT,'
  //       'ustaz TEXT,'
  //       'image TEXT,'
  //       'lastViewed TEXT,'
  //       'isFav INTEGER,'
  //       'isStarted INTEGER,'
  //       'isFinished INTEGER,'
  //       'pausedAtAudioNum INTEGER,'
  //       'pausedAtAudioSec INTEGER,'
  //       "scheduleDates TEXT,"
  //       "scheduleTime TEXT,"
  //       'isScheduleOn INTEGER,'
  //       'pdfPage DOUBLE,'
  //       'pdfNum DOUBLE,'
  //       'totalDuration INTEGER,'
  //       'audioSizes TEXT,'
  //       'isCompleted INTEGER'
  //       ')');
  // }

  //check
  Future<bool> isCourseAvailable(String courseId) async {
    Database? db = await database;
    try {
      var result = await db!.query(DatabaseConst.savedCourses,
          where: 'courseId = ?', whereArgs: [courseId]);
      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<List<CourseModel>> searchCourses(String val) async {
    final db = await database;
    final searchQuery = '%$val%';

    const String query = '''
      SELECT * FROM courses
      WHERE title LIKE ?
      ORDER BY title
    ''';

    final List<Map<String, dynamic>> result =
        await db!.rawQuery(query, [searchQuery]);

    List<CourseModel> courses = [];
    for (var d in result) {
      courses.add(CourseModel.fromMap(d, d["courseId"]));
    }

    return courses;
  }

  //geting data
  Future<List<CourseModel>> getCourseHistories() async {
    Database? db = await database;

    var result = await db!.query(
      DatabaseConst.savedCourses,
      orderBy: 'lastViewed DESC',
      // limit: 10,
    );
    List<CourseModel> courses = [];
    for (var courseDb in result) {
      courses
          .add(CourseModel.fromMap(courseDb, courseDb['courseId'] as String));
    }
    return courses;
  }

  Future<List<CourseModel>> getSavedCourses() async {
    Database? db = await database;

    var result =
        await db!.query(DatabaseConst.savedCourses, orderBy: 'lastViewed DESC');
    List<CourseModel> courses = [];
    for (var courseDb in result) {
      courses
          .add(CourseModel.fromMap(courseDb, courseDb['courseId'] as String));
    }
    return courses;
  }

  Future<CourseModel?> getSingleCourse(String courseId) async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.savedCourses,
        where: 'courseId = ?', whereArgs: [courseId]);
    List<CourseModel> courses = [];
    for (var courseDb in result) {
      courses
          .add(CourseModel.fromMap(courseDb, courseDb['courseId'] as String));
    }
    return courses.isEmpty ? null : courses.first;
  }

  Future<List<Map<String, dynamic>>> getCouses(
      String? key, dynamic val, SortingMethod method, int offset) async {
    final orderByColumn =
        method == SortingMethod.dateDSC ? 'dateTime' : 'title';
    final orderByDescending = method == SortingMethod.dateDSC ? 1 : 0;

    final db = await database;

    String query = "";
    List<Map<String, dynamic>> result = [];

    if (key == null) {
      query = '''
      SELECT * FROM ${DatabaseConst.savedCourses}
      ORDER BY $orderByColumn ${orderByDescending == 1 ? 'DESC' : 'ASC'}
      LIMIT $numOfDoc OFFSET $offset
      ''';
      result = await db!.rawQuery(query);
    } else {
      query = '''
      SELECT * FROM ${DatabaseConst.savedCourses}
      WHERE $key = ?
      ORDER BY $orderByColumn ${orderByDescending == 1 ? 'DESC' : 'ASC'}
      ''';
      result = await db!.rawQuery(query, [val]);
    }

    return result;
  }

  Future<List<String>> getCategories() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.cateogry);
    List<String> categories = [];
    for (var cat in result) {
      categories.add(cat['name'].toString());
    }

    return categories;
  }

  Future<List<String>> getUstazs() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.ustaz);
    List<String> categories = [];
    for (var cat in result) {
      categories.add(cat['name'].toString());
    }

    return categories;
  }

  Future<List<String>> getContent() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.content, orderBy: "name");
    List<String> contents = [];
    for (var cat in result) {
      contents.add(cat['name'].toString());
    }

    return contents;
  }

  Future<List<FAQModel>> getFaqs() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.faq);
    List<FAQModel> categories = [];
    for (var d in result) {
      categories.add(FAQModel.fromMap(d, ""));
    }

    return categories;
  }

  Future<List<CourseModel>> getStartedCourses() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.savedCourses,
        orderBy: 'lastViewed DESC', where: 'isStarted = ?', whereArgs: [1]);
    List<CourseModel> courses = [];
    for (var courseDb in result) {
      courses
          .add(CourseModel.fromMap(courseDb, courseDb['courseId'] as String));
    }
    courses.sort((a, b) => b.lastViewed.compareTo(a.lastViewed));
    return courses;
  }

  Future<List<CourseModel>> getFavCourses() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.savedCourses,
        orderBy: 'lastViewed ASC', where: 'isFav = ?', whereArgs: [1]);

    List<CourseModel> tasks = [];
    for (var taskDb in result) {
      tasks.add(CourseModel.fromMap(taskDb, taskDb['courseId'] as String));
    }
    return tasks;
  }

  //inserting data
  // Future<int> insertCourse(CourseModel courseModel) async {
  //   Database? db = await database;
  //   var result =
  //       await db!.insert(DatabaseConst.savedCourses, courseModel.toMap());

  //   return result;
  // }

  //update data
  Future<int> updateCourse(CourseModel courseModel) async {
    var db = await database;
    var result = await db!.update(
        DatabaseConst.savedCourses, courseModel.toMap(),
        where: 'id = ?', whereArgs: [courseModel.id]);

    return result;
  }

  //deleta data
  Future<int> deleteCourse(int id) async {
    var db = await database;
    var result = await db!
        .rawDelete('DELETE FROM ${DatabaseConst.savedCourses} WHERE id = $id');

    return result;
  }
}
