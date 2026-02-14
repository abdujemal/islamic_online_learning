// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AssignedCourse {
  final String id;
  final int courseId;
  final String title;
  final int order;
  final String description;
  final String curriculumId;
  final Course? course;
  AssignedCourse({
    required this.id,
    required this.courseId,
    required this.title,
    required this.order,
    required this.description,
    required this.curriculumId,
    this.course,
  });

  AssignedCourse copyWith({
    String? id,
    int? courseId,
    String? title,
    int? order,
    String? description,
    String? curriculumId,
    Course? course,
  }) {
    return AssignedCourse(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      curriculumId: curriculumId ?? this.curriculumId,
      title: title ?? this.title,
      order: order ?? this.order,
      description: description ?? this.description,
      course: course ?? this.course,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'courseId': courseId,
      'title': title,
      'order': order,
      'description': description,
      "curriculumId": curriculumId,
      'Course': course?.toMap(),
    };
  }

  factory AssignedCourse.fromMap(Map<String, dynamic> map,
      {bool fromDb = false}) {
    print("AssignedCourse.fromMap");
    return AssignedCourse(
      id: map['id'] as String,
      courseId: map['courseId'] as int,
      title: map['title'] as String,
      order: map['order'] as int,
      description: map['description'] as String,
      curriculumId: map["curriculumId"] as String,
      course: map['Course'] != null
          ? fromDb
              ? Course.fromJson(map['Course'] as String)
              : Course.fromMap(
                  map['Course'] as Map<String, dynamic>,
                )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignedCourse.fromJson(String source) =>
      AssignedCourse.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AssignedCourse(id: $id, courseId: $courseId, curriculumId: $curriculumId, title: $title, order: $order, description: $description, course: $course)';
  }

  @override
  bool operator ==(covariant AssignedCourse other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.courseId == courseId &&
        other.title == title &&
        other.order == order &&
        other.description == description &&
        other.curriculumId == curriculumId &&
        other.course == course;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        courseId.hashCode ^
        title.hashCode ^
        order.hashCode ^
        curriculumId.hashCode ^
        description.hashCode ^
        course.hashCode;
  }
}

class Course {
  final String courseId;
  final String pdfId;
  final List<int> pdfSize;
  final String image;
  final String ustaz;
  final String category;
  Course({
    required this.courseId,
    required this.pdfId,
    required this.image,
    required this.ustaz,
    required this.category,
    required this.pdfSize,
  });

  Course copyWith({
    String? courseId,
    String? pdfId,
    List<int>? pdfSize,
    String? image,
    String? ustaz,
    String? category,
  }) {
    return Course(
        courseId: courseId ?? this.courseId,
        pdfId: pdfId ?? this.pdfId,
        image: image ?? this.image,
        ustaz: ustaz ?? this.ustaz,
        category: category ?? this.category,
        pdfSize: pdfSize ?? this.pdfSize);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseId': courseId,
      'pdfId': pdfId,
      'image': image,
      'ustaz': ustaz,
      'category': category,
      'pdfSize': pdfSize
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
        courseId: map['courseId'] as String,
        pdfId: map['pdfId'] as String,
        image: map['image'] as String,
        ustaz: map['ustaz'] as String,
        category: map['category'] as String,
        pdfSize:
            (map["pdfSize"] as List<dynamic>).map((e) => e as int).toList());
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) =>
      Course.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Course(courseId: $courseId, pdfId: $pdfId, image: $image, ustaz: $ustaz, category: $category, pdfSize: $pdfSize)';
  }

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;

    return other.courseId == courseId &&
        other.pdfId == pdfId &&
        other.image == image &&
        other.ustaz == ustaz &&
        other.pdfSize == pdfSize &&
        other.category == category;
  }

  @override
  int get hashCode {
    return courseId.hashCode ^
        pdfId.hashCode ^
        image.hashCode ^
        ustaz.hashCode ^
        pdfSize.hashCode ^
        category.hashCode;
  }
}
