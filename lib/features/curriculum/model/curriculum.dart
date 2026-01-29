// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:islamic_online_learning/features/curriculum/model/assigned_course.dart';
import 'package:islamic_online_learning/features/curriculum/model/lesson.dart';

class Curriculum {
  final String id;
  final String title;
  final String description;
  final String updatedOn;
  final bool active;
  final bool prerequisite;
  final int level;
  final List<AssignedCourse>? assignedCourses;
  final List<Lesson>? lessons;
  Curriculum({
    required this.id,
    required this.title,
    required this.description,
    required this.active,
    required this.prerequisite,
    required this.level,
    required this.updatedOn,
    this.assignedCourses,
    this.lessons,
  });

  Curriculum copyWith({
    String? id,
    String? title,
    String? description,
    String? updatedOn,
    bool? active,
    bool? prerequisite,
    int? level,
    List<AssignedCourse>? assignedCourses,
    List<Lesson>? lessons,
  }) {
    return Curriculum(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      updatedOn: updatedOn ?? this.updatedOn,
      active: active ?? this.active,
      prerequisite: prerequisite ?? this.prerequisite,
      level: level ?? this.level,
      assignedCourses: assignedCourses ?? this.assignedCourses,
      lessons: lessons ?? this.lessons,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'active': active,
      'prerequisite': prerequisite,
      'level': level,
      'updatedOn': updatedOn,
      'assignedCourses': assignedCourses?.map((x) => x.toMap()).toList(),
      'lessons': lessons?.map((x) => x.toMap()).toList(),
    };
  }

  static List<Curriculum> listFromJson(String responseBody,
      {bool fromDb = false}) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Curriculum.fromMap(json)).toList();
  }

  factory Curriculum.fromMap(Map<String, dynamic> map, {bool fromDb = false}) {
    print("Curriculum.fromMap");
    return Curriculum(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      updatedOn: map['updatedOn'] as String,
      active:
          fromDb ? (map["active"] == 1 ? true : false) : map['active'] as bool,
      prerequisite: fromDb
          ? (map["prerequisite"] == 1 ? true : false)
          : map['prerequisite'] as bool,
      level: map['level'] as int,
      assignedCourses: map['assignedCourses'] != null
          ? List<AssignedCourse>.from(
              (map['assignedCourses'] as List<dynamic>).map<AssignedCourse>(
                (x) => AssignedCourse.fromMap(
                  x as Map<String, dynamic>,
                ),
              ),
            )
          : null,
      lessons: map['lessons'] != null
          ? List<Lesson>.from(
              (map['lessons'] as List<dynamic>).map<Lesson>(
                (x) => Lesson.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Curriculum.fromJson(String source) =>
      Curriculum.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Curriculum(id: $id, title: $title, updatedOn: $updatedOn, description: $description, active: $active, prerequisite: $prerequisite, level: $level, assignedCourses: $assignedCourses, lessons: $lessons)';
  }

  @override
  bool operator ==(covariant Curriculum other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.active == active &&
        other.prerequisite == prerequisite &&
        other.level == level &&
        other.updatedOn == updatedOn &&
        listEquals(other.assignedCourses, assignedCourses) &&
        listEquals(other.lessons, lessons);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        active.hashCode ^
        prerequisite.hashCode ^
        level.hashCode ^
        assignedCourses.hashCode ^
        updatedOn.hashCode ^
        lessons.hashCode;
  }
}
