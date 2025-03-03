import 'package:elex_driver/common/map_screen.dart';
import 'package:elex_driver/layout/screens/main_layout.dart';
import 'package:elex_driver/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:elex_driver/modules/auth/screens/login_screen.dart';
import 'package:elex_driver/modules/auth/screens/signup_screen.dart';
import 'package:elex_driver/modules/auth/screens/verify_screen.dart';
import 'package:elex_driver/modules/home/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/layout',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/layout', builder: (context, state) => const MainLayout()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signUp', builder: (context, state) => const SignupPage()),
    GoRoute(path: '/verify', builder: (context, state) => const VerifyPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreenPage()),
    GoRoute(path: '/map', builder: (context, state) => MapScreen())
  ],
);
