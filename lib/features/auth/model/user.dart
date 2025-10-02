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
