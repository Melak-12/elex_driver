import 'package:elex_driver/layout/screens/main_layout.dart';
import 'package:elex_driver/modules/gas/screens/gas_screen.dart';
import 'package:elex_driver/modules/map/screens/map_screen.dart';
import 'package:elex_driver/modules/profile/screens/profile_screen.dart';
import 'package:elex_driver/onboarding_screen.dart';
import 'package:elex_driver/splash.dart';
import 'package:go_router/go_router.dart';
import 'package:elex_driver/modules/auth/screens/login_screen.dart';
import 'package:elex_driver/modules/auth/screens/signup_screen.dart';
import 'package:elex_driver/modules/auth/screens/verify_screen.dart';
import 'package:elex_driver/modules/home/screens/home_screen.dart';

const String onBoarding = '/';
const String layout = '/layout';
const String splash = '/splash';
const String login = '/login';
const String signUp = '/signUp';
const String verify = '/verify';
const String home = '/home';
const String map = '/map';
const String gas = '/gas';
const String profile = '/profile';

final GoRouter appRouter = GoRouter(
  initialLocation: splash,
  routes: [
    GoRoute(
        path: onBoarding,
        builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
    GoRoute(path: layout, builder: (context, state) => const MainLayout()),
    GoRoute(path: login, builder: (context, state) => const LoginPage()),
    GoRoute(path: signUp, builder: (context, state) => const SignupPage()),
    GoRoute(path: verify, builder: (context, state) => const VerifyPage()),
    GoRoute(path: home, builder: (context, state) => const HomePage()),
    GoRoute(path: map, builder: (context, state) => const MapScreen()),
    GoRoute(path: gas, builder: (context, state) => const GasDeliveryPage()),
    GoRoute(path: profile, builder: (context, state) => const ProfilePage()),
  ],
);
