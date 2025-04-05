import 'package:elex_driver/modules/documents/screens/document_screen.dart';
import 'package:elex_driver/modules/food/screens/food_screen.dart';
import 'package:elex_driver/modules/gas/screens/gas_screen.dart';
import 'package:elex_driver/modules/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const FoodDeliveryPage(),
    const GasDeliveryPage(),
    const DocumentDeliveryPage(),
  ];

  int get currentIndex => _currentIndex;
  List<Widget> get pages => _pages;

  void changePage(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
