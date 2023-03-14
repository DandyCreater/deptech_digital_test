part of 'update_user_bloc.dart';

abstract class UpdateUserState extends Equatable {
  const UpdateUserState();

  @override
  List<Object> get props => [];
}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserLoading extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {
  final UserEntity? value;
  const UpdateUserSuccess({required this.value});

  @override
  // TODO: implement props
  List<Object> get props => [value!];
}

class UpdateUserFailed extends UpdateUserState {
  final String? message;

  const UpdateUserFailed({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message!];
}
