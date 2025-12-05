// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:islamic_online_learning/features/auth/model/group_request.dart';

class Group {
  final String id;
  final String name;
  final int lessonNum;
  final int courseNum;
  final String curriculumId;
  final String gender;
  final String ageGroup;
  final String discussionTime;
  final String discussionDay;
  final String timeZone;
  final DateTime? startDate;
  final DateTime? currStartDate;
  final DateTime? courseStartDate;
  final DateTime createdAt;
  final int? noOfMembers;
  final int noOfLessonsPerDay;
  final List<Member>? members;
  final GroupRequest? groupUpdateRequest;
  Group({
    required this.id,
    required this.name,
    required this.lessonNum,
    required this.courseNum,
    required this.curriculumId,
    required this.gender,
    required this.ageGroup,
    required this.discussionTime,
    required this.discussionDay,
    required this.timeZone,
    required this.noOfLessonsPerDay,
    this.startDate,
    this.currStartDate,
    this.courseStartDate,
    required this.createdAt,
    this.noOfMembers,
    this.members,
    this.groupUpdateRequest,
  });

  Group copyWith({
    String? id,
    String? name,
    int? lessonNum,
    int? courseNum,
    int? noOfLessonsPerDay,
    String? curriculumId,
    String? gender,
    String? ageGroup,
    String? discussionTime,
    String? discussionDay,
    String? timeZone,
    DateTime? startDate,
    DateTime? currStartDate,
    DateTime? courseStartDate,
    DateTime? createdAt,
    int? noOfMembers,
    List<Member>? members,
    GroupRequest? groupUpdateRequest,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      lessonNum: lessonNum ?? this.lessonNum,
      courseNum: courseNum ?? this.courseNum,
      curriculumId: curriculumId ?? this.curriculumId,
      gender: gender ?? this.gender,
      noOfLessonsPerDay: noOfLessonsPerDay ?? this.noOfLessonsPerDay,
      ageGroup: ageGroup ?? this.ageGroup,
      discussionTime: discussionTime ?? this.discussionTime,
      discussionDay: discussionDay ?? this.discussionDay,
      timeZone: timeZone ?? this.timeZone,
      startDate: startDate ?? this.startDate,
      currStartDate: currStartDate ?? this.currStartDate,
      courseStartDate: courseStartDate ?? this.courseStartDate,
      createdAt: createdAt ?? this.createdAt,
      noOfMembers: noOfMembers ?? this.noOfMembers,
      members: members ?? this.members,
      groupUpdateRequest: groupUpdateRequest ?? this.groupUpdateRequest,
    );
  }

  static List<Group> listFromJson(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((json) => Group.fromMap(json)).toList();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'lessonNum': lessonNum,
      'courseNum': courseNum,
      'curriculumId': curriculumId,
      'gender': gender,
      'ageGroup': ageGroup,
      'discussionTime': discussionTime,
      'discussionDay': discussionDay,
      'noOfLessonsPerDay': noOfLessonsPerDay,
      'timeZone': timeZone,
      'startDate': startDate,
      'currStartDate': currStartDate,
      'courseStartDate': courseStartDate,
      'createdAt': createdAt,
      'noOfMembers': noOfMembers,
      'members': members?.map((x) => x.toMap()).toList(),
      'groupUpdateRequest': groupUpdateRequest?.toMap(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] as String,
      name: map['name'] as String,
      lessonNum: map['lessonNum'] as int,
      courseNum: map['courseNum'] as int,
      noOfLessonsPerDay: map["noOfLessonsPerDay"] as int,
      curriculumId: map['curriculumId'] as String,
      gender: map['gender'] as String,
      ageGroup: map['ageGroup'] as String,
      discussionTime: map['discussionTime'] as String,
      discussionDay: map['discussionDay'] as String,
      timeZone: map['timeZone'] as String,
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'] as String)
          : null,
      currStartDate: map['currStartDate'] != null
          ? DateTime.parse(map['currStartDate'] as String)
          : null,
      courseStartDate: map['courseStartDate'] != null
          ? DateTime.parse(map['courseStartDate'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      noOfMembers: map['_count'] == null ? null : map['_count']["members"],
      members: map['members'] != null
          ? List<Member>.from(
              (map['members'] as List<dynamic>).map<Member?>(
                (x) => Member.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      groupUpdateRequest: map['groupUpdateRequest'] != null
          ? GroupRequest.fromMap(
              map['groupUpdateRequest'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) =>
      Group.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Group(id: $id, name: $name, lessonNum: $lessonNum, noOfLessonsPerDay: $noOfLessonsPerDay, courseNum: $courseNum, curriculumId: $curriculumId, gender: $gender, ageGroup: $ageGroup, discussionTime: $discussionTime, discussionDay: $discussionDay, timeZone: $timeZone, startDate: $startDate, currStartDate: $currStartDate, courseStartDate: $courseStartDate, createdAt: $createdAt, noOfMembers: $noOfMembers, members: $members, groupUpdateRequest: $groupUpdateRequest)';
  }

  @override
  bool operator ==(covariant Group other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.lessonNum == lessonNum &&
        other.courseNum == courseNum &&
        other.curriculumId == curriculumId &&
        other.gender == gender &&
        other.noOfLessonsPerDay == noOfLessonsPerDay &&
        other.ageGroup == ageGroup &&
        other.discussionTime == discussionTime &&
        other.discussionDay == discussionDay &&
        other.timeZone == timeZone &&
        other.startDate == startDate &&
        other.currStartDate == currStartDate &&
        other.courseStartDate == courseStartDate &&
        other.createdAt == createdAt &&
        other.noOfMembers == noOfMembers &&
        listEquals(other.members, members) &&
        other.groupUpdateRequest == groupUpdateRequest;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        lessonNum.hashCode ^
        courseNum.hashCode ^
        curriculumId.hashCode ^
        gender.hashCode ^
        noOfLessonsPerDay.hashCode ^
        ageGroup.hashCode ^
        discussionTime.hashCode ^
        discussionDay.hashCode ^
        timeZone.hashCode ^
        startDate.hashCode ^
        currStartDate.hashCode ^
        courseStartDate.hashCode ^
        createdAt.hashCode ^
        noOfMembers.hashCode ^
        members.hashCode ^
        groupUpdateRequest.hashCode;
  }
}

class Member {
  final String id;
  final String name;
  Member({
    required this.id,
    required this.name,
  });

  Member copyWith({
    String? id,
    String? name,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) =>
      Member.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Member(id: $id, name: $name)';

  @override
  bool operator ==(covariant Member other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
