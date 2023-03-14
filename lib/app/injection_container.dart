import 'package:dep_tech/data/datasource/remote_data_source.dart';
import 'package:dep_tech/data/repository/data_repository.dart';
import 'package:dep_tech/domain/repository/domain_repository.dart';
import 'package:dep_tech/domain/usecase/agenda_usecase.dart';
import 'package:dep_tech/domain/usecase/auth_usecase.dart';
import 'package:dep_tech/presentation/bloc/agenda/add-agenda/add_agenda_bloc.dart';
import 'package:dep_tech/presentation/bloc/agenda/edit-agenda/edit_agenda_bloc.dart';
import 'package:dep_tech/presentation/bloc/agenda/list-agenda/list_agenda_bloc.dart';
import 'package:dep_tech/presentation/bloc/auth/login-bloc/login_bloc.dart';
import 'package:dep_tech/presentation/bloc/auth/register-bloc/register_bloc.dart';
import 'package:dep_tech/presentation/bloc/auth/update-user-bloc/update_user_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future init() async {
  //Bloc
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => UpdateUserBloc(sl()));

  sl.registerFactory(() => AddAgendaBloc(sl()));
  sl.registerFactory(() => ListAgendaBloc(sl(), sl()));
  sl.registerFactory(() => EditAgendaBloc(sl()));

  //UseCase
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => EditAgendaUseCase(sl()));

  sl.registerLazySingleton(() => AddAgendaUseCase(sl()));
  sl.registerLazySingleton(() => ListAgendaUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAgendaUseCase(sl()));

  //Repository
  sl.registerLazySingleton<DomainRepository>(
      () => DataRepository(remoteDataSourceImpl: sl()));

  //Datasources
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());
}
