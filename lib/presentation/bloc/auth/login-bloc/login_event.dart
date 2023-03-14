part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class StartLogin extends LoginEvent {
  final LoginParamaterPost? value;

  const StartLogin({required this.value});
  @override
  // TODO: implement props
  List<Object> get props => [value!];
}
