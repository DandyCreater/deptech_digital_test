import 'package:dep_tech/app/injection_container.dart';
import 'package:dep_tech/presentation/bloc/agenda/add-agenda/add_agenda_bloc.dart';
import 'package:dep_tech/presentation/bloc/agenda/edit-agenda/edit_agenda_bloc.dart';
import 'package:dep_tech/presentation/bloc/agenda/list-agenda/list_agenda_bloc.dart';
import 'package:dep_tech/presentation/bloc/auth/login-bloc/login_bloc.dart';
import 'package:dep_tech/presentation/bloc/auth/register-bloc/register_bloc.dart';
import 'package:dep_tech/presentation/bloc/auth/update-user-bloc/update_user_bloc.dart';
import 'package:dep_tech/presentation/screen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final loginBloc = sl<LoginBloc>();
    final registerBloc = sl<RegisterBloc>();
    final updateUserBloc = sl<UpdateUserBloc>();

    final addAgendaBloc = sl<AddAgendaBloc>();
    final listAgendaBloc = sl<ListAgendaBloc>();
    final editAgendaBloc = sl<EditAgendaBloc>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => loginBloc),
        BlocProvider(create: (_) => registerBloc),
        BlocProvider(create: (_) => updateUserBloc),
        BlocProvider(create: (_) => addAgendaBloc),
        BlocProvider(create: (_) => listAgendaBloc),
        BlocProvider(create: (_) => editAgendaBloc),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
