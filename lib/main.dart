import 'package:elex_driver/modules/home/providers/home_provider.dart';
import 'package:elex_driver/modules/orders/providers/order_provider.dart';
import 'package:elex_driver/modules/profile/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elex_driver/modules/auth/providers/auth_provider.dart';
import 'package:elex_driver/modules/auth/providers/signup_provider.dart';
import 'package:elex_driver/modules/auth/providers/verify_provider.dart';
import 'package:elex_driver/providers/map_provider.dart';
import 'package:elex_driver/layout/providers/main_provider.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/routes/app_router.dart';

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
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: MaterialApp.router(
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
        routerConfig: appRouter,
        
      ),
    
    );
  }
}
