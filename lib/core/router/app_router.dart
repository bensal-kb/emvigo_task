import 'package:emvigo_test/features/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:emvigo_test/core/router/app_routes.dart';
import 'package:emvigo_test/dependencies/get_dependencies.dart';
import 'package:emvigo_test/features/auth/view/auth_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: appData.navigatorKey,
    initialLocation: Routes.main,
    redirect: (context, state) async {
      if (prefs.getAuthToken() == null && !prefs.isGuestUser()) {
        return Routes.auth;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.main,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: Routes.auth,
        builder: (context, state) => const AuthPage(),
      ),
      // Add routes here as you create features
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );
}
