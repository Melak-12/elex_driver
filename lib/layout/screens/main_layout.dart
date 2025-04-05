import 'package:elex_driver/core/constants/dimentsions.dart';
import 'package:elex_driver/modules/orders/screens/orders_screen.dart';
import 'package:elex_driver/modules/home/screens/home_screen.dart';
import 'package:elex_driver/modules/profile/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
          height: screenHeight(context, h: 0.06),
          border:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
          iconSize: 30,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining_sharp),
              label: 'Delivered',
            ),
           
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Users',
            ),
          ]),
      tabBuilder: (_, index) {
        switch (index) {
          case 0:
            return const HomePage();
          case 1:
            return const OrdersPage();

          case 2:
            return  ProfilePage();
          default:
            return Container();
        }
      },
    );
  }
}
