import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dep_tech/data/model/agenda_response_model.dart';
import 'package:dep_tech/data/model/register_response_model.dart';
import 'package:dep_tech/data/model/user_response_model.dart';
import 'package:dep_tech/domain/entity/agenda_entity.dart';
import 'package:dep_tech/domain/entity/user_entity.dart';

abstract class DomainRepository {
  Future<Either<String, UserEntity>> login(LoginParamaterPost value);
  Future<Either<String, UserEntity>> register(RegisterParameterPost value);
  Future<Either<String, UserEntity>> updateUser(
      RegisterParameterPost value, bool changePassword, String newPassword);

  Future<Either<String, AgendaEntity>> addAgenda(
      AgendaParameterPost agenda, File image);
  Future<Either<String, List<AgendaEntity>>> listAgenda();
  Future<Either<String, List<AgendaEntity>>> deleteItem(String uId);
  Future<Either<String, String>> editAgenda(
      AgendaParameterPost agenda,String uId);
}
