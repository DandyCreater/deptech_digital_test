import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dep_tech/data/model/agenda_response_model.dart';
import 'package:dep_tech/domain/entity/agenda_entity.dart';
import 'package:dep_tech/domain/usecase/agenda_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'add_agenda_event.dart';
part 'add_agenda_state.dart';

class AddAgendaBloc extends Bloc<AddAgendaEvent, AddAgendaState> {
  final AddAgendaUseCase addAgendaUseCase;
  AddAgendaBloc(this.addAgendaUseCase) : super(AddAgendaInitial()) {
    on<AddAgenda>((event, emit) async {
      try {
        final result =
            await addAgendaUseCase.execute(event.agenda!, event.image!);
        result.fold((failure) {
          emit(AddAgendaFailed(message: failure));
        }, (response) {
          emit(AddAgendaSuccess(value: response));
        });
      } catch (e) {
        debugPrint("Bloc Add Agenda Error $e");
        emit(const AddAgendaFailed(
            message: "Something Wrong, Please Try Again!"));
      }
    });
  }
}
