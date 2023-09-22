// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../domain/user_entity.dart';

class UserModel extends UserEntity {
  final String email;
  final String name;
  const UserModel({
    required this.email,
    required this.name,
  }) : super(
          email: email,
          name: name,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
