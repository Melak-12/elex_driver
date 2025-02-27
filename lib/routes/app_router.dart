import 'package:elex_driver/layout/screens/main_layout.dart';
import 'package:elex_driver/modules/auth/screens/login_screen.dart';
import 'package:elex_driver/modules/auth/screens/signup_screen.dart';
import 'package:elex_driver/modules/auth/screens/verify_screen.dart';
import 'package:elex_driver/modules/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const String layout = '/layout';
  static const String homePage = '/home';
  static const String loginPage = '/login';
  static const String signUp = '/signUp';
  static const String verify = '/verify';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case verify:
        return MaterialPageRoute(builder: (_) => const VerifyPage());
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomeScreenPage());
      case layout:
        return MaterialPageRoute(builder: (_) => const MainLayout());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
