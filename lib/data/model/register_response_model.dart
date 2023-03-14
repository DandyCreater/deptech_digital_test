import 'dart:io';

class RegisterParameterPost {
  final String? bornDate;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final File? profilePict;

  const RegisterParameterPost(
      {required this.bornDate,
      required this.email,
      required this.password,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.profilePict});

  factory RegisterParameterPost.fromJson(Map<String, dynamic> json) {
    return RegisterParameterPost(
        bornDate: json['bornDate'],
        email: json['email'],
        password: json['password'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gender: json['gender'],
        profilePict: json['profilePict']);
  }
}
