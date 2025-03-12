import 'package:elex_driver/core/constants/app_constants.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  // Mock data for orders with dates and order types
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-1234',
      'customer': 'John Doe',
      'address': '123 Main St, Anytown',
      'time': '10:30 AM',
      'items': 3,
      'price': 24.99,
      'status': 'completed',
      'distance': '2.5 km',
      'date': DateTime.now(),
      'type': 'Food',
    },
    {
      'id': 'ORD-5678',
      'customer': 'Jane Smith',
      'address': '456 Oak Ave, Somewhere',
      'time': '11:15 AM',
      'items': 1,
      'price': 12.50,
      'status': 'completed',
      'distance': '3.8 km',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'Document',
    },
    {
      'id': 'ORD-9012',
      'customer': 'Robert Johnson',
      'address': '789 Pine Rd, Elsewhere',
      'time': '12:00 PM',
      'items': 5,
      'price': 43.75,
      'status': 'declined',
      'distance': '1.2 km',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'type': 'Gas',
    },
    {
      'id': 'ORD-3456',
      'customer': 'Sarah Williams',
      'address': '321 Cedar Ln, Nowhere',
      'time': '1:30 PM',
      'items': 2,
      'price': 18.25,
      'status': 'completed',
      'distance': '4.5 km',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'type': 'Food',
    },
  ];

  Map<String, List<Map<String, dynamic>>> _groupOrders() {
    final Map<String, List<Map<String, dynamic>>> grouped = {
      'Today': [],
      'Yesterday': [],
      'Previous': [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var order in _orders) {
      final orderDate = (order['date'] as DateTime);
      final orderDay = DateTime(orderDate.year, orderDate.month, orderDate.day);

      if (orderDay == today) {
        grouped['Today']!.add(order);
      } else if (orderDay == yesterday) {
        grouped['Yesterday']!.add(order);
      } else {
        grouped['Previous']!.add(order);
      }
    }

    return grouped;
  }

  Widget _buildOrderTypeChip(String type) {
    Color chipColor;
    IconData iconData;

    switch (type.toLowerCase()) {
      case 'food':
        chipColor = Colors.orange;
        iconData = Icons.restaurant;
        break;
      case 'document':
        chipColor = Colors.blue;
        iconData = Icons.description;
        break;
      case 'gas':
        chipColor = Colors.green;
        iconData = Icons.local_gas_station;
        break;
      default:
        chipColor = Colors.grey;
        iconData = Icons.category;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 16, color: chipColor),
          const SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    IconData iconData;
    switch (status.toLowerCase()) {
      case 'completed': // Fix the typo here
        badgeColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case 'declined':
        badgeColor = Colors.red;
        iconData = Icons.cancel;
        break;
      default:
        badgeColor = Colors.grey;
        iconData = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: badgeColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 16, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedOrders = _groupOrders();

    return Scaffold(
      appBar: AppBar(
    
      surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Order History',
          style:AppTextStyles.headline1,
        ),
       
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.filter_list,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              onPressed: () {
                // Add filter functionality here
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstant.horizontalPadding,
          ),
          child: ListView.builder(
            itemCount: groupedOrders.length,
            itemBuilder: (context, sectionIndex) {
              final section = groupedOrders.keys.elementAt(sectionIndex);
              final sectionOrders = groupedOrders[section]!;

              if (sectionOrders.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      section,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sectionOrders.length,
                    itemBuilder: (context, index) {
                      final order = sectionOrders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order['id'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  _buildOrderTypeChip(order['type']),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.person_outline,
                                          size: 18, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        order['customer'],
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  _buildStatusBadge(order['status']),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 18, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      order['address'],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 18, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${order['time']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.shopping_bag_outlined,
                                      size: 18, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${order['items']} items',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '\$${order['price'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
