// lib/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/game/presentation/screen/game_screen.dart';
import '../features/login/presentataion/screen/login_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import 'route_constants.dart';

import '../helpers/shared_pref.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splash,

    redirect: (context, state) async {
      final isGoogleLoggedIn = await SharedPrefsHelper().isGoogleLoggedIn();
      final isGuestLoggedIn = await SharedPrefsHelper().isGuestLoggedIn();

      // Handle splash screen
      if (state.matchedLocation == RouteConstants.splash) {
        return null;
      }

      // Redirect to login if neither Google nor guest login is active
      if (!isGoogleLoggedIn && !isGuestLoggedIn && state.matchedLocation != RouteConstants.login) {
        return RouteConstants.login;
      }

      // Redirect to game if either Google or guest login is active
      if ((isGoogleLoggedIn || isGuestLoggedIn) && state.matchedLocation == RouteConstants.login) {
        return RouteConstants.game;
      }

      return null; // No redirection
    },

    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: RouteConstants.game,
        builder: (context, state) => GameScreen(),
      ),
    ],
  );
}
