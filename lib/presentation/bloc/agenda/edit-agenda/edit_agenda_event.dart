part of 'edit_agenda_bloc.dart';

abstract class EditAgendaEvent extends Equatable {
  const EditAgendaEvent();

  @override
  List<Object> get props => [];
}

class StartEditAgenda extends EditAgendaEvent {
  final AgendaParameterPost? agenda;
  final String? uId;
  const StartEditAgenda({required this.agenda, required this.uId});

  @override
  // TODO: implement props
  List<Object> get props => [agenda!, uId!];
}
