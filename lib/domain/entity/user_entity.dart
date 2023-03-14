class UserEntity {
  final String? id;
  final String? bornDate;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? profilePict;

  const UserEntity(
      {required this.id,
      required this.bornDate,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.profilePict});
}
