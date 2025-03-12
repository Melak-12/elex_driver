import 'package:elex_driver/common/map_screen.dart';
import 'package:elex_driver/core/constants/app_constants.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/modules/home/screens/deiver_orders_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import "package:live_indicator/live_indicator.dart";

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.black.withOpacity(0.2),
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: [
              Image.asset('assets/images/Logo.png', height: 30),
              const SizedBox(width: 8),
            ],
          ),
          actions: [
            _buildIconWithBadge(Icons.notifications, '2', () {}),
            _buildIconWithBadge(Icons.shopping_cart, '2', () {}),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstant.horizontalPadding),
              child: _buildTabs(),
            ),
            const SizedBox(height: 10),
            Expanded(
                child: _selectedTab == 0
                    ? const DriverOrdersPage()
                    : const MapScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _buildTabButton("Deliveries", 0),
        const SizedBox(width: 8),
        _buildTabButton("Map View", 1),
      ],
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
          // context.go(index == 0 ? '/map' : '/map');
        },
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.flag_fill, color: AppColors.primary),
              LiveIndicator(
                color: Colors.greenAccent.shade700,
                radius: 5.5,
                spreadRadius: 8,
                spreadDuration: const Duration(microseconds: 100),
                waitDuration: const Duration(milliseconds: 500),
              )
            ],
          ),
          const Text(
            "Today: 7 Deliveries • 1500birr",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithBadge(IconData icon, String count, VoidCallback onTap) {
    return Stack(
      children: [
        IconButton(
            icon: Icon(icon, color: AppColors.primary), onPressed: onTap),
        Positioned(
          right: 7,
          top: 5,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration:
                const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: Text(count,
                style: const TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
