import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import "package:live_indicator/live_indicator.dart";

class HomeScreenPage extends StatelessWidget {
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bodyColor,
        appBar: AppBar(
          leading: Image.asset(
            'assets/images/Logo.png',
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
          backgroundColor: AppColors.appBarColor,
          title: const Text(
            'Home',
            style: AppTextStyles.headline2,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF663399),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.location_on,
                                    size: 24, color: Colors.white),
                              ),
                              Positioned(
                                top: 0,
                                left: 18,
                                child: LiveIndicator(
                                  color: Colors.greenAccent.shade700,
                                  radius: 5.5,
                                  spreadRadius: 8,
                                  spreadDuration:
                                      const Duration(microseconds: 100),
                                  waitDuration:
                                      const Duration(milliseconds: 500),
                                ),
                              ),
                            ],
                          ),
                         
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Arada, Addis Ababa',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Text(
                            '2:00:34',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search Pending Orders',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Icon(Icons.search),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/map'),
                          icon: const Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Map',
                            style: AppTextStyles.buttonText,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.gas_meter_outlined),
                        title: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 0),
                          decoration: BoxDecoration(
                            // color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ORD-123',
                            style: AppTextStyles.headline3,
                          ),
                        ),
                        subtitle: const Text(
                          "Cylinder Delivery",
                          style: TextStyle(color: AppColors.primary),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.amber[900]!),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Pending',
                                style: TextStyle(
                                  color: Colors.amber[900],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            const Text("34:00 am")
                          ],
                        ),
                      ),
                      Container(
                        decoration:const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildListRow(
                                Icons.account_circle_rounded, "Selecom Hailu"),
                            _buildListRow(Icons.location_on, "From",
                                "Alem Bank, Addis Ababa"),
                            _buildListRow(Icons.location_on, "To",
                                "Merkato, Addis Ababa"),
                            _buildListRow(
                                Icons.phone, "Phone", "+251-945-3453-32"),
                            _buildListRow(Icons.timer, "Time", "2:58 pm"),
                            _buildListRow(Icons.timer, "Distance", "23KM"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListRow(IconData icon, String title, [String? subtitle]) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: subtitle == null
            ? 18
            : 10, // Large gap for first item, small for others
        bottom: 4,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary2,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: AppColors.primary2,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2), // Reduce spacing
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
