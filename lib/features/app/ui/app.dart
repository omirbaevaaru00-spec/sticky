import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stiky/data/auth/auth_repository_impl.dart';
import 'package:stiky/features/app/bloc/user_bloc.dart';

class App extends StatelessWidget {
  final Widget child;
  const App({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserBloc(
        authRepository: AuthRepositoryImpl.instance,
      )..add(const UserStarted()), 
      child: child,
    );
  }
}
