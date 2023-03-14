import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dep_tech/data/model/agenda_response_model.dart';
import 'package:dep_tech/domain/usecase/agenda_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'edit_agenda_event.dart';
part 'edit_agenda_state.dart';

class EditAgendaBloc extends Bloc<EditAgendaEvent, EditAgendaState> {
  final EditAgendaUseCase editagendaUseCase;
  EditAgendaBloc(this.editagendaUseCase) : super(EditAgendaInitial()) {
    on<StartEditAgenda>((event, emit) async {
      emit(EditAgendaLoading());
      try {
        final result = await editagendaUseCase.execute(
            event.agenda!,event.uId!);
        result.fold((failure) {
          emit(EditAgendaFailed(message: failure));
        }, (response) {
          emit(EditAgendaSuccess(message: response));
        });
      } catch (e) {
        debugPrint("Bloc Edit Agenda Error $e");
        emit(const EditAgendaFailed(
            message: "Something Wrong, Please Try Again!"));
      }
    });
  }
}
