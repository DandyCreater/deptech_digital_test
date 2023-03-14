part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class StartRegistration extends RegisterEvent {
  final RegisterParameterPost value;

  const StartRegistration({required this.value});
  @override
  // TODO: implement props
  List<Object> get props => [value];
}
