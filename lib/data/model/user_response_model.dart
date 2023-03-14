// ignore_for_file: unnecessary_this

import 'package:dep_tech/domain/entity/user_entity.dart';

class UserResponseModel {
  final String? id;
  final String? bornDate;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? profilePict;

  const UserResponseModel(
      {required this.id,
      required this.bornDate,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.profilePict});

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
        id: json['id'],
        bornDate: json['bornDate'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gender: json['gender'],
        profilePict: json['profilePict']);
  }

  UserEntity toEntity() {
    return UserEntity(
        id: this.id,
        bornDate: this.bornDate,
        email: this.email,
        firstName: this.firstName,
        lastName: this.lastName,
        gender: this.gender,
        profilePict: this.profilePict);
  }
}

class LoginParamaterPost {
  final String? email;
  final String? password;

  const LoginParamaterPost({required this.email, required this.password});

  factory LoginParamaterPost.fromJson(Map<String, dynamic> json) {
    return LoginParamaterPost(email: json['email'], password: json['password']);
  }
}
