// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AssignedCourse {
  final String id;
  final int courseId;
  final String title;
  final int order;
  final String description;
  final Course? course;
  AssignedCourse({
    required this.id,
    required this.courseId,
    required this.title,
    required this.order,
    required this.description,
    this.course,
  });

  AssignedCourse copyWith({
    String? id,
    int? courseId,
    String? title,
    int? order,
    String? description,
    Course? course,
  }) {
    return AssignedCourse(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
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
      'course': course?.toMap(),
    };
  }

  factory AssignedCourse.fromMap(Map<String, dynamic> map) {
    return AssignedCourse(
      id: map['id'] as String,
      courseId: map['courseId'] as int,
      title: map['title'] as String,
      order: map['order'] as int,
      description: map['description'] as String,
      course: map['Course'] != null
          ? Course.fromMap(
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
    return 'AssignedCourse(id: $id, courseId: $courseId, title: $title, order: $order, description: $description, course: $course)';
  }

  @override
  bool operator ==(covariant AssignedCourse other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.courseId == courseId &&
        other.title == title &&
        other.order == order &&
        other.description == description &&
        other.course == course;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        courseId.hashCode ^
        title.hashCode ^
        order.hashCode ^
        description.hashCode ^
        course.hashCode;
  }
}

class Course {
  final String pdfId;
  final String image;
  Course({
    required this.pdfId,
    required this.image,
  });

  Course copyWith({
    String? pdfId,
    String? image,
  }) {
    return Course(
      pdfId: pdfId ?? this.pdfId,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pdfId': pdfId,
      'image': image,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      pdfId: map['pdfId'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Course(pdfId: $pdfId, image: $image)';

  @override
  bool operator ==(covariant Course other) {
    if (identical(this, other)) return true;
  
    return 
      other.pdfId == pdfId &&
      other.image == image;
  }

  @override
  int get hashCode => pdfId.hashCode ^ image.hashCode;
}
