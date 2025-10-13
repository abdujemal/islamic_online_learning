import 'package:sqflite/sqflite.dart';

class CurriculumDbHelper {
  static final CurriculumDbHelper instance = CurriculumDbHelper._init();
  static Database? _database;

  CurriculumDbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('curriculumData.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = "$dbPath/$filePath";

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Curriculum (
        i INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT UNIQUE,
        title TEXT,
        description TEXT,
        active INTEGER,
        prerequisite INTEGER,
        level INTEGER,
        updatedOn TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE AssignedCourse (
        i INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT UNIQUE,
        courseId INTEGER,
        title TEXT,
        "order" INTEGER,
        description TEXT,
        curriculumId TEXT,
        Course Text,
        FOREIGN KEY (curriculumId) REFERENCES Curriculum (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE Lesson (
        i INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT UNIQUE,
        "order" INTEGER,
        "startPage" INTEGER,
        title TEXT,
        audioUrl TEXT,
        assignedCourseId TEXT,
        curriculumId TEXT,
        FOREIGN KEY (assignedCourseId) REFERENCES AssignedCourse (id) ON DELETE CASCADE,
        FOREIGN KEY (curriculumId) REFERENCES Curriculum (id) ON DELETE CASCADE
      )
    ''');
  }

  // ---------- CRUD for Curriculum ----------

  Future<Map<String, dynamic>?> getCurriculumWithDetails(
      String? curriculumId, int courseOrder) async {
    final db = await instance.database;

    // 1️⃣ Fetch the curriculum
    final curriculumResult = await db.query(
      'Curriculum',
      where: 'id = ?',
      whereArgs: [curriculumId],
    );

    if (curriculumResult.isEmpty) {
      return null;
    }
    Map<String, dynamic> curriculum = curriculumResult.first;

    // 2️⃣ Fetch assigned courses for this curriculum
    final assignedCourses = await db.query(
      'AssignedCourse',
      where: 'curriculumId = ?',
      whereArgs: [curriculumId],
      orderBy: '"order" ASC',
    );

    final assignedCourse = await db.query(
      'AssignedCourse',
      where: 'curriculumId = ? AND "order" = ?',
      whereArgs: [curriculumId, courseOrder],
    );

    // print("assignedCourseResult: $assignedCourse");

    if (assignedCourse.isEmpty) return null;

    // 3️⃣ Fetch lessons for the first assigned course
    final lessons = await db.query(
      'Lesson',
      where: 'assignedCourseId = ?',
      whereArgs: [assignedCourse.first['id']],
      orderBy: '"order" ASC',
    );
    curriculum = {
      ...curriculum,
      ...{"lessons": lessons}
    };

    // 4️⃣ Attach courses to curriculum
    curriculum = {
      ...curriculum,
      ...{"assignedCourses": assignedCourses}
    };
    // print("curriculumResult: $curriculum");

    return curriculum;
  }

  Future<void> insertCurriculum(Map<String, dynamic> data) async {
    final db = await instance.database;
    //update if exists, insert if not
    int count = await db.update(
      'Curriculum',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
    // If nothing was updated, insert new
    if (count == 0) {
      await db.insert(
        'Curriculum',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getCurriculums() async {
    final db = await instance.database;
    return await db.query('Curriculum');
  }

  Future<void> deleteCurriculum(String id) async {
    final db = await instance.database;
    await db.delete('Curriculum', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- CRUD for AssignedCourse ----------

  Future<void> insertAssignedCourse(Map<String, dynamic> data) async {
    final db = await instance.database;
    int count = await db.update(
      "AssignedCourse",
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
    if (count == 0) {
      await db.insert('AssignedCourse', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Map<String, dynamic>>> getAssignedCourses(
      String curriculumId) async {
    final db = await instance.database;
    return await db.query('AssignedCourse',
        where: 'curriculumId = ?', whereArgs: [curriculumId]);
  }

  Future<void> deleteAssignedCourse(String id) async {
    final db = await instance.database;
    await db.delete('AssignedCourse', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- CRUD for Lesson ----------

  Future<void> insertLesson(Map<String, dynamic> data) async {
    final db = await instance.database;
    int count = await db.update(
      "Lesson",
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
    if (count == 0) {
      await db.insert('Lesson', data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Map<String, dynamic>>> getLessons(String assignedCourseId) async {
    final db = await instance.database;
    return await db.query('Lesson',
        where: 'assignedCourseId = ?', whereArgs: [assignedCourseId]);
  }

  Future<void> deleteLesson(String id) async {
    final db = await instance.database;
    await db.delete('Lesson', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- Utility ----------

  Future<int> countAllAndPrint() async {
    final db = await instance.database;
    final curriculumCount = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM Curriculum')) ??
        0;
    final assignedCourseCount = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM AssignedCourse')) ??
        0;
    final lessonCount = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM Lesson')) ??
        0;

    final totalCount = curriculumCount + assignedCourseCount + lessonCount;

    print('Curriculums: $curriculumCount');
    print('AssignedCourses: $assignedCourseCount');
    print('Lessons: $lessonCount');
    print('Total entries: $totalCount');

    return totalCount;
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('Lesson');
    await db.delete('AssignedCourse');
    await db.delete('Curriculum');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
