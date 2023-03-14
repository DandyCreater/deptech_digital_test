part of 'list_agenda_bloc.dart';

abstract class ListAgendaState extends Equatable {
  const ListAgendaState();

  @override
  List<Object> get props => [];
}

class ListAgendaInitial extends ListAgendaState {}

class ListAgendaLoading extends ListAgendaState {}

class ListAgendaSuccess extends ListAgendaState {
  final List<AgendaEntity>? value;

  const ListAgendaSuccess({required this.value});

  @override
  // TODO: implement props
  List<Object> get props => [value!];
}

class ListAgendaFailed extends ListAgendaState {
  final String? message;

  const ListAgendaFailed({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message!];
}
