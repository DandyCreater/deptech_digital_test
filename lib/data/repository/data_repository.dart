import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dep_tech/data/datasource/remote_data_source.dart';
import 'package:dep_tech/data/model/agenda_response_model.dart';
import 'package:dep_tech/data/model/register_response_model.dart';
import 'package:dep_tech/data/model/user_response_model.dart';
import 'package:dep_tech/domain/entity/agenda_entity.dart';
import 'package:dep_tech/domain/entity/user_entity.dart';
import 'package:dep_tech/domain/repository/domain_repository.dart';
import 'package:flutter/material.dart';

class DataRepository extends DomainRepository {
  final RemoteDataSource remoteDataSourceImpl;

  DataRepository({required this.remoteDataSourceImpl});

  @override
  Future<Either<String, UserEntity>> login(LoginParamaterPost value) async {
    try {
      UserResponseModel result = await remoteDataSourceImpl.logIn(value);
      if (result.id != null) {
        return right(result.toEntity());
      } else {
        return left(result.firstName!);
      }
    } catch (e) {
      debugPrint("Catch Data Repository Login Error $e");
      return const Left("Something Wrong, Please Try Again!");
    }
  }

  @override
  Future<Either<String, UserEntity>> register(
      RegisterParameterPost value) async {
    try {
      UserResponseModel result = await remoteDataSourceImpl.register(value);
      if (result.id != null) {
        return right(result.toEntity());
      } else {
        return left(result.firstName!);
      }
    } catch (e) {
      debugPrint("Catch Data Repository Register Error $e");
      return const Left("Something Wrong, Please Try Again!");
    }
  }

  @override
  Future<Either<String, UserEntity>> updateUser(RegisterParameterPost value,
      bool changePassword, String newPassword) async {
    try {
      UserResponseModel result = await remoteDataSourceImpl.updateUser(
          value, changePassword, newPassword);
      if (result.id != null) {
        return right(result.toEntity());
      } else {
        return left(result.firstName!);
      }
    } catch (e) {
      debugPrint("Catch Data Repository Update User Error $e");
      return const Left("Something Wrong, Please Try Again!");
    }
  }

  @override
  Future<Either<String, AgendaEntity>> addAgenda(
      AgendaParameterPost agenda, File image) async {
    try {
      AgendaResponseModel result =
          await remoteDataSourceImpl.addAgenda(agenda, image);
      if (result.id != null) {
        return right(result.toEntity());
      } else {
        return left(result.description!);
      }
    } catch (e) {
      debugPrint("Catch Data Repository Add Agenda Error $e");
      return const Left("Something Wrong, Please Try Again!");
    }
  }

  @override
  Future<Either<String, List<AgendaEntity>>> listAgenda() async {
    try {
      List<AgendaEntity> resultEntity = [];
      List<AgendaResponseModel> result =
          await remoteDataSourceImpl.agendaList();
      for (var items in result) {
        resultEntity.add(items.toEntity());
      }
      if (resultEntity != null) {
        return right(resultEntity);
      } else {
        return left("Tambah Data Error");
      }
    } catch (e) {
      debugPrint("Catch Data Repository List Agenda Error $e");
      return const Left("Something Wrong, Please Try Again!");
    }
  }

  @override
  Future<Either<String, List<AgendaEntity>>> deleteItem(String uId) async {
    try {
      List<AgendaEntity> resultEntity = [];
      List<AgendaResponseModel> result =
          await remoteDataSourceImpl.deleteItem(uId);
      for (var items in result) {
        resultEntity.add(items.toEntity());
      }
      if (resultEntity != null) {
        return right(resultEntity);
      } else {
        return left("Delete Data Error");
      }
    } catch (e) {
      debugPrint("Catch Data Repository Delete Agenda Error $e");
      return const Left("Something Wrong, Please Try Again!");
    }
  }

  @override
  Future<Either<String, String>> editAgenda(
      AgendaParameterPost agenda, String uId) async {
    try {
      String result = await remoteDataSourceImpl.editAgenda(agenda, uId);
      if (result == "OK") {
        return right(result);
      } else {
        return left("Edit Data Error");
      }
    } catch (e) {
      debugPrint("Catch Data Repository Delete Agenda Error $e");
      return const Left("Something Wrong, Please Try Again!");
    }
  }
}
