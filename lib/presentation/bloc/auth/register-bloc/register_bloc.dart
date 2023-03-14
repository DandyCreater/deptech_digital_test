import 'package:bloc/bloc.dart';
import 'package:dep_tech/data/model/register_response_model.dart';
import 'package:dep_tech/domain/entity/user_entity.dart';
import 'package:dep_tech/domain/usecase/auth_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase registerUseCase;
  RegisterBloc(this.registerUseCase) : super(RegisterInitial()) {
    on<StartRegistration>((event, emit) async {
      emit(RegisterLoading());
      try {
        final result = await registerUseCase.execute(event.value);
        result.fold((failure) {
          emit(RegisterFailed(message: failure));
        }, (response) {
          emit(RegisterSuccess(value: response));
        });
      } catch (e) {
        debugPrint("BLOC Register Error $e");
        emit(const RegisterFailed(
            message: "Something Wrong, Please Try Again!"));
      }
    });
  }
}
