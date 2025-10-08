// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Lesson {
  final String id;
  final int order;
  final String title;
  final String audioUrl;
  final String assignedCourseId;
  final String curriculumId;
  Lesson({
    required this.id,
    required this.order,
    required this.title,
    required this.audioUrl,
    required this.assignedCourseId,
    required this.curriculumId,
  });

  Lesson copyWith({
    String? id,
    int? order,
    String? title,
    String? audioUrl,
    String? assignedCourseId,
    String? curriculumId,
  }) {
    return Lesson(
      id: id ?? this.id,
      order: order ?? this.order,
      title: title ?? this.title,
      audioUrl: audioUrl ?? this.audioUrl,
      assignedCourseId: assignedCourseId ?? this.assignedCourseId,
      curriculumId: curriculumId ?? this.curriculumId,
    );
  }

  static List<Lesson> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Lesson.fromMap(json)).toList();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order': order,
      'title': title,
      'audioUrl': audioUrl,
      'assignedCourseId': assignedCourseId,
      'curriculumId': curriculumId,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as String,
      order: map['order'] as int,
      title: map['title'] as String,
      audioUrl: map['audioUrl'] as String,
      assignedCourseId: map['assignedCourseId'] as String,
      curriculumId: map['curriculumId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lesson.fromJson(String source) =>
      Lesson.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Lesson(id: $id, order: $order, title: $title, audioUrl: $audioUrl, assignedCourseId: $assignedCourseId, curriculumId: $curriculumId)';
  }

  @override
  bool operator ==(covariant Lesson other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.order == order &&
        other.title == title &&
        other.audioUrl == audioUrl &&
        other.assignedCourseId == assignedCourseId &&
        other.curriculumId == curriculumId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        order.hashCode ^
        title.hashCode ^
        audioUrl.hashCode ^
        assignedCourseId.hashCode ^
        curriculumId.hashCode;
  }
}
