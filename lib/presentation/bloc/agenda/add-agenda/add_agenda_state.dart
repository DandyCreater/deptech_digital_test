part of 'add_agenda_bloc.dart';

abstract class AddAgendaState extends Equatable {
  const AddAgendaState();

  @override
  List<Object> get props => [];
}

class AddAgendaInitial extends AddAgendaState {}

class AddAgendaLoading extends AddAgendaState {}

class AddAgendaSuccess extends AddAgendaState {
  final AgendaEntity? value;

  const AddAgendaSuccess({required this.value});

  @override
  // TODO: implement props
  List<Object> get props => [value!];
}

class AddAgendaFailed extends AddAgendaState {
  final String? message;

  const AddAgendaFailed({required this.message});
  @override
  // TODO: implement props
  List<Object> get props => [message!];
}
