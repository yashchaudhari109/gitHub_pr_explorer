import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_pr_explorer/app/router.dart';
import 'package:github_pr_explorer/core/di/injector.dart';
import 'package:github_pr_explorer/features/auth/bloc/auth_bloc.dart';
import 'package:github_pr_explorer/features/auth/bloc/auth_event.dart';
import 'package:github_pr_explorer/features/auth/data/repository/auth_repository.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (context) =>
                  AuthBloc(authRepository: getIt<AuthRepository>())
                    ..add(AuthStatusChecked()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter(authBloc: context.read<AuthBloc>()).router;

          return MaterialApp.router(
            title: 'GitHub PR Viewer',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),

            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
