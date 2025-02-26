import 'package:elex_driver/modules/auth/providers/auth_provider.dart';
import 'package:elex_driver/modules/auth/providers/signup_provider.dart';
import 'package:elex_driver/modules/auth/providers/verify_provider.dart';
import 'package:elex_driver/providers/map_provider.dart';
import 'package:elex_driver/routes/app_router.dart';
import 'package:elex_driver/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elex_driver/layout/providers/main_provider.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => VerifyProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elex Driver',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.primary,
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: RouteManager.generateRoute,
        home: const OnboardingScreen(),
      ),
    );
  }
}
