import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dep_tech/data/model/agenda_response_model.dart';
import 'package:dep_tech/domain/entity/agenda_entity.dart';
import 'package:dep_tech/domain/repository/domain_repository.dart';

class AddAgendaUseCase {
  final DomainRepository repository;

  AddAgendaUseCase(this.repository);

  Future<Either<String, AgendaEntity>> execute(
      AgendaParameterPost agenda, File image) async {
    return repository.addAgenda(agenda, image);
  }
}

class ListAgendaUseCase {
  final DomainRepository repository;

  ListAgendaUseCase(this.repository);

  Future<Either<String, List<AgendaEntity>>> execute() async {
    return repository.listAgenda();
  }
}

class DeleteAgendaUseCase {
  final DomainRepository repository;

  DeleteAgendaUseCase(this.repository);
  Future<Either<String, List<AgendaEntity>>> execute(String uId) async {
    return repository.deleteItem(uId);
  }
}

class EditAgendaUseCase {
  final DomainRepository repository;

  EditAgendaUseCase(this.repository);
  Future<Either<String, String>> execute(
      AgendaParameterPost agenda, String uId) async {
    return repository.editAgenda(agenda, uId);
  }
}
