// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:islamic_online_learning/features/auth/model/group.dart';

class User {
  final String id;
  final String name;
  final String phone;
  final String timeZone;
  final DateTime dob;
  final String gender;
  final int numOfStreaks;
  final List<String> previousLearning;
  final Group group;
  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.timeZone,
    required this.dob,
    required this.gender,
    required this.numOfStreaks,
    required this.previousLearning,
    required this.group,
  });

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? timeZone,
    DateTime? dob,
    String? gender,
    int? numOfStreaks,
    List<String>? previousLearning,
    Group? group,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      timeZone: timeZone ?? this.timeZone,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      numOfStreaks: numOfStreaks ?? this.numOfStreaks,
      previousLearning: previousLearning ?? this.previousLearning,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'timeZone': timeZone,
      'dob': dob.millisecondsSinceEpoch,
      'gender': gender,
      'numOfStreaks': numOfStreaks,
      'previousLearning': previousLearning,
      'group': group.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      timeZone: map['timeZone'] as String,
      dob: DateTime.parse(map['dob'] as String),
      gender: map['gender'] as String,
      numOfStreaks: map['numOfStreaks'] as int,
      previousLearning: List<String>.from((map['previousLearning'] as List<dynamic>)),
      group: Group.fromMap(map['group'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, phone: $phone, timeZone: $timeZone, dob: $dob, gender: $gender, numOfStreaks: $numOfStreaks, previousLearning: $previousLearning, group: $group)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.phone == phone &&
      other.timeZone == timeZone &&
      other.dob == dob &&
      other.gender == gender &&
      other.numOfStreaks == numOfStreaks &&
      listEquals(other.previousLearning, previousLearning) &&
      other.group == group;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      timeZone.hashCode ^
      dob.hashCode ^
      gender.hashCode ^
      numOfStreaks.hashCode ^
      previousLearning.hashCode ^
      group.hashCode;
  }
}

class UserInput {
  final String name;
  final String dob;
  final String gender;
  final List<String> previousLearning;
  final String discussionTime;
  final String discussionDay;
  final String otpId;
  final String curriculumId;
  final String timeZone;
  final String? groupId;
  UserInput({
    required this.name,
    required this.dob,
    required this.gender,
    required this.previousLearning,
    required this.discussionTime,
    required this.discussionDay,
    required this.otpId,
    required this.curriculumId,
    required this.timeZone,
    this.groupId,
  });

  UserInput copyWith({
    String? name,
    String? dob,
    String? gender,
    List<String>? previousLearning,
    String? discussionTime,
    String? discussionDay,
    String? otpId,
    String? curriculumId,
    String? groupId,
    String? timeZone,
  }) {
    return UserInput(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      previousLearning: previousLearning ?? this.previousLearning,
      discussionTime: discussionTime ?? this.discussionTime,
      discussionDay: discussionDay ?? this.discussionDay,
      otpId: otpId ?? this.otpId,
      curriculumId: curriculumId ?? this.curriculumId,
      groupId: groupId ?? this.groupId,
      timeZone: timeZone ?? this.timeZone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'dob': dob,
      'gender': gender,
      'previousLearning': previousLearning,
      'discussionTime': discussionTime,
      'discussionDay': discussionDay,
      'otpId': otpId,
      'curriculumId': curriculumId,
      'groupId': groupId,
      "timeZone": timeZone,
    };
  }
}
