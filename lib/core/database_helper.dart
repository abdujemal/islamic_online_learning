import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:islamic_online_learning/features/main/data/course_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path =
        '${directory.path}/Islamic Online Learning/db/islamicOnlineLearnging.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
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
  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE ${DatabaseConst.savedCourses}('
        'id: INTEGER PRIMARY KEY AUTOINCREMENT,'
        'courseId TEXT,'
        'author: TEXT,'
        'category: TEXT,'
        'courseIds: TEXT,'
        'noOfRecord: TEXT,'
        'pdfId: TEXT,'
        'title: TEXT,'
        'ustaz: TEXT,'
        'lastViewed: TEXT,'
        'isFav: INTEGER,'
        'isDownloaded: INTEGER,'
        'audioMin: INTEGER,'
        'pdfPage: INTEGER,'
        ')');
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
      courses.add(CourseModel.fromMap(courseDb, courseDb['id'] as String));
    }
    return courses;
  }

  Future<List<CourseModel>> getDownloadedCourses() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.savedCourses,
        orderBy: 'lastViewed DESC', where: 'isDownloaded = ?', whereArgs: [1]);
    List<CourseModel> courses = [];
    for (var courseDb in result) {
      courses.add(CourseModel.fromMap(courseDb, courseDb['id'] as String));
    }
    return courses;
  }

  Future<List<CourseModel>> getFavCourses() async {
    Database? db = await database;

    var result = await db!.query(DatabaseConst.savedCourses,
        orderBy: 'lastViewed ASC', where: 'isFav = ?', whereArgs: [1]);
    List<CourseModel> tasks = [];
    for (var taskDb in result) {
      tasks.add(CourseModel.fromMap(taskDb, taskDb['id'] as String));
    }
    return tasks;
  }

  //inserting data
  Future<int> insertCourse(CourseModel courseModel) async {
    Database? db = await database;
    var result =
        await db!.insert(DatabaseConst.savedCourses, courseModel.toMap());

    return result;
  }

  //update data
  Future<int> updateTask(CourseModel courseModel) async {
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
