part of 'update_user_bloc.dart';

abstract class UpdateUserEvent extends Equatable {
  const UpdateUserEvent();

  @override
  List<Object> get props => [];
}

class StartUpdateUser extends UpdateUserEvent {
  final RegisterParameterPost? value;
  final String? newPassword;
  final bool changePassword;

  const StartUpdateUser(
      {required this.value,
      required this.newPassword,
      required this.changePassword});

  @override
  // TODO: implement props
  List<Object> get props => [value!];
}
