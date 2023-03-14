import 'package:dartz/dartz.dart';
import 'package:dep_tech/data/model/register_response_model.dart';
import 'package:dep_tech/data/model/user_response_model.dart';
import 'package:dep_tech/domain/entity/user_entity.dart';
import 'package:dep_tech/domain/repository/domain_repository.dart';

class LoginUseCase {
  final DomainRepository repository;

  LoginUseCase(this.repository);
  Future<Either<String, UserEntity>> execute(LoginParamaterPost value) {
    return repository.login(value);
  }
}

class RegisterUseCase {
  final DomainRepository repository;

  RegisterUseCase(this.repository);
  Future<Either<String, UserEntity>> execute(RegisterParameterPost value) {
    return repository.register(value);
  }
}

class UpdateUserUseCase {
  final DomainRepository repository;

  UpdateUserUseCase(this.repository);

  Future<Either<String, UserEntity>> execute(RegisterParameterPost value,
      bool changePassword, String newPassword) async {
    return repository.updateUser(value, changePassword, newPassword);
  }
}
