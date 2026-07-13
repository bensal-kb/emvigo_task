import 'package:flutter/material.dart';
import 'package:emvigo_test/core/enums/flavors.dart';

class AppData {
  final Flavors flavor;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AppData({required this.flavor});

  bool get isDev => flavor == Flavors.dev;
  bool get isStage => flavor == Flavors.stage;
  bool get isProd => flavor == Flavors.prod;

  BuildContext? get context => navigatorKey.currentContext;
}
