part of 'edit_agenda_bloc.dart';

abstract class EditAgendaState extends Equatable {
  const EditAgendaState();

  @override
  List<Object> get props => [];
}

class EditAgendaInitial extends EditAgendaState {}

class EditAgendaLoading extends EditAgendaState {}

class EditAgendaSuccess extends EditAgendaState {
  final String? message;

  const EditAgendaSuccess({required this.message});
  @override
  // TODO: implement props
  List<Object> get props => [message!];
}

class EditAgendaFailed extends EditAgendaState {
  final String? message;

  const EditAgendaFailed({required this.message});
  @override
  // TODO: implement props
  List<Object> get props => [message!];
}
