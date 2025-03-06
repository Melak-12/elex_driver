import 'package:elex_driver/common/map_screen.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/modules/documents/screens/document_screen.dart';
import 'package:elex_driver/modules/gas/screens/gas_screen.dart';
import 'package:elex_driver/modules/home/screens/deiver_orders_page.dart';
import 'package:elex_driver/modules/home/screens/home_screen.dart';
import 'package:elex_driver/modules/home/screens/order_history.dart';
import 'package:elex_driver/modules/profile/screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        // backgroundColor: AppColors.primary.withOpacity(0.9),
        height: MediaQuery.of(context).size.height * 0.06,border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      iconSize: 20,  items: const [
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(icon: 
        Icon(Icons.shopping_cart),
          label: 'Orders',
        ),
      
        
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.location_solid),
          label: 'Map view',
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Users',
        ),
      ]),
      tabBuilder: (_, index) {
        switch (index) {
          case 0:
            return const HomeScreenPage();
          case 1:
            return const OrderHistoryPage();
          case 2:
            return MapScreen();
          case 3:
            return  ProfilePage();
          default:
            return Container();
        }
      },
    );
  }
}
