import 'package:emvigo_test/features/create_profile/view/create_profile_page.dart';
import 'package:emvigo_test/features/home/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:emvigo_test/core/router/app_routes.dart';
import 'package:emvigo_test/dependencies/get_dependencies.dart';
import 'package:emvigo_test/features/auth/view/sign_in_page.dart';
import 'package:emvigo_test/features/auth/view/signup_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: appData.navigatorKey,
    initialLocation: Routes.main,
    redirect: (context, state) async {
      final isAuthenticated =
          firebaseAuth.currentUser != null || prefs.isGuestUser();
      final isPublicRoute =
          state.matchedLocation == Routes.signIn ||
          state.matchedLocation == Routes.signup;
      if (!isAuthenticated && !isPublicRoute) {
        return Routes.signup;
      }
      return null;
    },
    routes: [
      GoRoute(path: Routes.main, builder: (context, state) => const HomePage()),
      GoRoute(path: Routes.signIn, builder: (context, state) => const SignInPage()),
      GoRoute(
        path: Routes.signup,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: Routes.createProfile,
        builder: (context, state) => const CreateProfilePage(),
      ),
      // Add routes here as you create features
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
