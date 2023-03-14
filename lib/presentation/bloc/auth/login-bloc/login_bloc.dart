import 'package:bloc/bloc.dart';
import 'package:dep_tech/data/model/user_response_model.dart';
import 'package:dep_tech/domain/entity/user_entity.dart';
import 'package:dep_tech/domain/usecase/auth_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;
  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<StartLogin>((event, emit) async {
      emit(LoginLoading());
      try {
        final result = await loginUseCase.execute(event.value!);
        result.fold((failure) {
          emit(LoginFailed(message: failure));
        }, (response) {
          emit(LoginSuccess(value: response));
        });
      } catch (e) {
        debugPrint("Bloc Login Error $e");
        emit(const LoginFailed(message: "Something Wrong, Please Try Again!"));
      }
    });
  }
}
