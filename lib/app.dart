import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emvigo_test/core/router/app_router.dart';
import 'package:emvigo_test/core/styles/app_theme.dart';
import 'package:emvigo_test/dependencies/get_dependencies.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: sl<AppTheme>(),
      child: Builder(
        builder: (context) => MaterialApp.router(
          title: 'Emvigo Test',
          theme: sl<AppTheme>().getTheme(context),
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
