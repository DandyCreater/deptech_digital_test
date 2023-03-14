part of 'add_agenda_bloc.dart';

abstract class AddAgendaEvent extends Equatable {
  const AddAgendaEvent();

  @override
  List<Object> get props => [];
}

class AddAgenda extends AddAgendaEvent {
  final AgendaParameterPost? agenda;
  final File? image;

  const AddAgenda({required this.agenda, required this.image});

  @override
  // TODO: implement props
  List<Object> get props => [agenda!, image!];
}
