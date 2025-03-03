import 'package:elex_driver/common/map_screen.dart';
import 'package:elex_driver/modules/documents/screens/document_screen.dart';
import 'package:elex_driver/modules/gas/screens/gas_screen.dart';
import 'package:elex_driver/modules/home/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold( 
      tabBar:
          CupertinoTabBar( items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_gas_station),
          label: 'Gas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.document_scanner),
          label: 'Documents',
        ),
      ]),
      tabBuilder: (_, index) {
        switch (index) {
          case 0:
            return  const HomeScreenPage();
          case 1:
            return   MapScreen();
          case 2:
            return  const GasDeliveryPage();
          case 3:
            return  const DocumentDeliveryPage();
          default:
            return Container();
        }
      },
    );
  }
}
