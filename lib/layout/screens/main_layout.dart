import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/layout/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainProvider(),
      child: Consumer<MainProvider>(
        builder: (context, mainProvider, child) {
          return Scaffold(
            body: mainProvider.pages[mainProvider.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: AppColors.primary,
              currentIndex: mainProvider.currentIndex,
              onTap: mainProvider.changePage,
              selectedItemColor: AppColors.secondary,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood),
                  label: 'Food',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_gas_station),
                  label: 'Gas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.document_scanner),
                  label: 'Documents',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
