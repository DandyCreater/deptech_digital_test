part of 'list_agenda_bloc.dart';

abstract class ListAgendaEvent extends Equatable {
  const ListAgendaEvent();

  @override
  List<Object> get props => [];
}

class FetchAgendaList extends ListAgendaEvent {
  @override
  // TODO: implement props
  List<Object> get props => super.props;
}

class DeleteAgendaList extends ListAgendaEvent {
  final String uId;

  const DeleteAgendaList({required this.uId});
  @override
  // TODO: implement props
  List<Object> get props => [uId];
}
