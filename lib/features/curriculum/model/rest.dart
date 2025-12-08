// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Rest {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final int numOfDays;
  final String reason;
  final int? afterLesson;
  Rest({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.numOfDays,
    required this.reason,
    this.afterLesson,
  });

  Rest copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    int? numOfDays,
    String? reason,
    int? afterLesson,
  }) {
    return Rest(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      numOfDays: numOfDays ?? this.numOfDays,
      reason: reason ?? this.reason,
      afterLesson: afterLesson ?? this.afterLesson,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'startDate': startDate.toString(),
      'endDate': endDate.toString(),
      'numOfDays': numOfDays,
      'reason': reason,
      'afterLesson': afterLesson,
    };
  }

  factory Rest.fromMap(Map<String, dynamic> map) {
    return Rest(
      id: map['id'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      numOfDays: map['numOfDays'] as int,
      reason: map['reason'] as String,
      afterLesson: map['afterLesson'] != null ? map['afterLesson'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Rest.fromJson(String source) => Rest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Rest(id: $id, startDate: $startDate, endDate: $endDate, numOfDays: $numOfDays, reason: $reason, afterLesson: $afterLesson)';
  }

  @override
  bool operator ==(covariant Rest other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.numOfDays == numOfDays &&
      other.reason == reason &&
      other.afterLesson == afterLesson;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      numOfDays.hashCode ^
      reason.hashCode ^
      afterLesson.hashCode;
  }
}
