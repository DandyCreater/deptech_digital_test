import 'package:bloc/bloc.dart';
import 'package:dep_tech/data/model/register_response_model.dart';
import 'package:dep_tech/domain/entity/user_entity.dart';
import 'package:dep_tech/domain/usecase/auth_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'update_user_event.dart';
part 'update_user_state.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UpdateUserUseCase updateUserUseCase;
  UpdateUserBloc(this.updateUserUseCase) : super(UpdateUserInitial()) {
    on<StartUpdateUser>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        final result = await updateUserUseCase.execute(
            event.value!, event.changePassword, event.newPassword!);
        result.fold((failure) {
          emit(UpdateUserFailed(message: failure));
        }, (response) {
          emit(UpdateUserSuccess(value: response));
        });
      } catch (e) {
        debugPrint("Bloc Update User Error $e");
        emit(const UpdateUserFailed(
            message: "Something Wrong, Please Try Again!"));
      }
    });
  }
}
