import 'package:bloc/bloc.dart';
import 'package:dep_tech/domain/entity/agenda_entity.dart';
import 'package:dep_tech/domain/usecase/agenda_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'list_agenda_event.dart';
part 'list_agenda_state.dart';

class ListAgendaBloc extends Bloc<ListAgendaEvent, ListAgendaState> {
  final ListAgendaUseCase listAgendaUseCase;
  final DeleteAgendaUseCase deleteAgendaUseCase;
  ListAgendaBloc(this.listAgendaUseCase, this.deleteAgendaUseCase)
      : super(ListAgendaInitial()) {
    on<FetchAgendaList>((event, emit) async {
      emit(ListAgendaLoading());
      try {
        final result = await listAgendaUseCase.execute();
        result.fold((failure) {
          emit(ListAgendaFailed(message: failure));
        }, (response) {
          emit(ListAgendaSuccess(value: response));
        });
      } catch (e) {
        debugPrint("Bloc List Agenda Error $e");
        emit(const ListAgendaFailed(
            message: "Something Wrong, Please Try Again!"));
      }
    });

    on<DeleteAgendaList>((event, emit) async {
      emit(ListAgendaLoading());
      try {
        final result = await deleteAgendaUseCase.execute(event.uId);
        result.fold((failure) {
          emit(ListAgendaFailed(message: failure));
        }, (response) {
          emit(ListAgendaSuccess(value: response));
        });
      } catch (e) {
        debugPrint("Bloc Delete Agenda Error $e");
        emit(const ListAgendaFailed(
            message: "Something Wrong, Please Try Again!"));
      }
    });
  }
}
