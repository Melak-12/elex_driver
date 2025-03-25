import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:go_router/go_router.dart';
import "package:live_indicator/live_indicator.dart";

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Delivery Orders',
          style: AppTextStyles.headline2,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
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
                      children: const [
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
            const SizedBox(height: 16), // Space after the header

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      leading: const Icon(Icons.gas_meter_outlined),
                      title: Text(
                        order['orderId']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(order['type']!),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Delivered',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                      children: [
                        _buildListTile(Icons.account_circle_rounded, "Customer",
                            order['customer']!),
                        _buildListTile(
                            Icons.location_on, "From", order['from']!),
                        _buildListTile(Icons.location_on, "To", order['to']!),
                        _buildListTile(Icons.phone, "Phone", order['phone']!),
                        _buildListTile(Icons.timer, "Time", order['time']!),
                        _buildListTile(
                            Icons.route, "Distance", order['distance']!),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Change return type to Widget to accommodate custom widgets
  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8), // Custom padding
      decoration: BoxDecoration(
        color: AppColors.primary, // Set background color to primary
        // borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary2,
          ),
          SizedBox(width: 12), // Add space between icon and text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: AppColors.primary2)),
              Text(subtitle, style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> orders = [
  {
    'orderId': 'ORD-123',
    'type': 'Cylinder Delivery',
    'status': 'Pending',
    'customer': 'Selecom Hailu',
    'from': 'Alem Bank, Addis Ababa',
    'to': 'Merkato, Addis Ababa',
    'phone': '+251-945-3453-32',
    'time': '2:58 pm',
    'distance': '23KM',
  },
  {
    'orderId': 'ORD-124',
    'type': 'Gas Refill',
    'status': 'Completed',
    'customer': 'Tadesse Melaku',
    'from': 'Bole, Addis Ababa',
    'to': 'Megenagna, Addis Ababa',
    'phone': '+251-987-6543-21',
    'time': '4:30 pm',
    'distance': '15KM',
  },
];
