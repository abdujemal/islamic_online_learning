// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:islamic_online_learning/features/auth/model/group.dart';
// import 'package:islamic_online_learning/features/auth/model/subscription.dart';

class User {
  final String id;
  final String name;
  final String phone;
  final String timeZone;
  final String ageRange;
  final String gender;
  final int numOfStreaks;
  final List<String> previousLearning;
  final Group group;
  // final Subscription subscription;
  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.timeZone,
    required this.ageRange,
    required this.gender,
    required this.numOfStreaks,
    required this.previousLearning,
    required this.group,
    // required this.subscription,
  });

  User copyWith({
    String? id,
    String? name,
    String? phone,
    String? timeZone,
    String? ageRange,
    String? gender,
    int? numOfStreaks,
    List<String>? previousLearning,
    Group? group,
    // Subscription? subscription,
  }) {
    return User(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        timeZone: timeZone ?? this.timeZone,
        ageRange: ageRange ?? this.ageRange,
        gender: gender ?? this.gender,
        numOfStreaks: numOfStreaks ?? this.numOfStreaks,
        previousLearning: previousLearning ?? this.previousLearning,
        group: group ?? this.group
        // subscription: subscription ?? this.subscription
        )
        ;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'phone': phone,
      'timeZone': timeZone,
      'ageRange': ageRange,
      'gender': gender,
      'numOfStreaks': numOfStreaks,
      'previousLearning': previousLearning,
      'group': group.toMap(),
      // 'subscription': subscription.toMap()
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    print("User.fromMap");
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      timeZone: map['timeZone'] as String,
      ageRange: map["ageRange"] as String,
      gender: map['gender'] as String,
      numOfStreaks: map['numOfStreaks'] as int,
      previousLearning:
          List<String>.from((map['previousLearning'] as List<dynamic>)),
      group: Group.fromMap(
        map['group'] as Map<String, dynamic>,
      ),
      // subscription: Subscription.fromMap(
      //   map['subscription'] as Map<String, dynamic>,
      // ),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, phone: $phone, timeZone: $timeZone, ageRange: $ageRange, gender: $gender, numOfStreaks: $numOfStreaks, previousLearning: $previousLearning, group: $group)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.phone == phone &&
        other.timeZone == timeZone &&
        other.ageRange == ageRange &&
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
        ageRange.hashCode ^
        gender.hashCode ^
        numOfStreaks.hashCode ^
        previousLearning.hashCode ^
        group.hashCode;
  }
}

class UserInput {
  final String name;
  final String ageRange;
  final String gender;
  final List<String> previousLearning;
  // final String discussionTime;
  // final String discussionDay;
  final String otpId;
  final String curriculumId;
  final String? groupId;
  final String city;
  final String country;
  UserInput({
    required this.name,
    required this.ageRange,
    required this.gender,
    required this.previousLearning,
    // required this.discussionTime,
    // required this.discussionDay,
    required this.otpId,
    required this.curriculumId,
    this.groupId,
    required this.city,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'gender': gender,
      "ageRange": ageRange,
      'previousLearning': previousLearning,
      // 'discussionTime': discussionTime,
      // 'discussionDay': discussionDay,
      'otpId': otpId,
      'curriculumId': curriculumId,
      'city': city,
      'country': country,
      if (groupId != null) ...{
        'groupId': groupId,
      }
    };
  }

  factory UserInput.fromMap(Map<String, dynamic> map) {
    return UserInput(
      name: map['name'] as String,
      gender: map['gender'] as String,
      ageRange: map["ageRange"] as String,
      previousLearning:
          List<String>.from((map['previousLearning'] as List<String>)),
      // discussionTime: map['discussionTime'] as String,
      // discussionDay: map['discussionDay'] as String,
      otpId: map['otpId'] as String,
      curriculumId: map['curriculumId'] as String,
      groupId: map['groupId'] != null ? map['groupId'] as String : null,
      city: map['city'] as String,
      country: map['country'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInput.fromJson(String source) =>
      UserInput.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum AgeRange {
  Under_13,
  a13_17,
  a18_29,
  a30_49,
  a50_plus,
}

enum SafeAgeRange {
  a13_17,
  a18_29,
  a30_49,
  a50_plus,
}
