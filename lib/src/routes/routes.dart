import 'package:flutter/material.dart';
import 'package:trippy/src/feature/screen/login_screen/page/login_form.dart';
import 'package:trippy/src/feature/screen/splash_screen/page/splash_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => const SplashScreenPage(),
        );

      case '/user-login-screen':
        return MaterialPageRoute(
          builder: (context) => const LoginScreenPage(),
        );

      default:
        return null;
    }
  }
}
