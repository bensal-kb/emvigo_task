import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:emvigo_test/core/styles/app_theme.dart';
import 'package:emvigo_test/core/styles/theme.dart';

export 'package:emvigo_test/core/base/base_bloc/base_states.dart';
export 'package:flutter/material.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:emvigo_test/dependencies/get_dependencies.dart';

extension BaseUI on BuildContext {
  Themes get theme => RepositoryProvider.of<AppTheme>(this).currentTheme;

  void removeFocus() => FocusManager.instance.primaryFocus?.unfocus();

  GoRouter get router => GoRouter.of(this);

  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}
