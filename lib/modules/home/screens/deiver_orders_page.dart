import 'package:elex_driver/core/constants/app_constants.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:flutter/material.dart';

class DriverOrdersPage extends StatefulWidget {
  const DriverOrdersPage({Key? key}) : super(key: key);

  @override
  _DriverOrdersPageState createState() => _DriverOrdersPageState();
}

class _DriverOrdersPageState extends State<DriverOrdersPage> {
  // Mock data for orders
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-1234',
      'customer': 'John Doe',
      'address': '123 Main St, Anytown',
      'time': '10:30 AM',
      'items': 3,
      'price': 24.99,
      'status': 'Pending',
      'distance': '2.5 km',
    },
    {
      'id': 'ORD-5678',
      'customer': 'Jane Smith',
      'address': '456 Oak Ave, Somewhere',
      'time': '11:15 AM',
      'items': 1,
      'price': 12.50,
      'status': 'Accepted',
      'distance': '3.8 km',
    },
    {
      'id': 'ORD-9012',
      'customer': 'Robert Johnson',
      'address': '789 Pine Rd, Elsewhere',
      'time': '12:00 PM',
      'items': 5,
      'price': 43.75,
      'status': 'Pending',
      'distance': '1.2 km',
    },
    {
      'id': 'ORD-3456',
      'customer': 'Sarah Williams',
      'address': '321 Cedar Ln, Nowhere',
      'time': '1:30 PM',
      'items': 2,
      'price': 18.25,
      'status': 'Completed',
      'distance': '4.5 km',
    },
  ];

  void _updateOrderStatus(int index, String newStatus) {
    setState(() {
      _orders[index]['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstant.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_orders.where((order) => order['status'] != 'Completed').length} active orders',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.withOpacity(0.1))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order['id'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,color: AppColors.primary
                                ),
                              ),
                              _buildStatusBadge(order['status']),
                            ],
                          ),
                          const SizedBox(height: 12),
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
                                order['time'],
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 16),
                              const Icon(Icons.shopping_bag_outlined,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                '${order['items']} items',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.route,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                order['distance'],
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
                          const SizedBox(height: 16),
                          _buildActionButtons(order['status'], index),
                        ],
                      ),
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
  Widget _buildStatusBadge(String status) {
    Color ringColor;
    Color textColor;

    switch (status) {
      case 'Pending':
        ringColor = Colors.orange;
        textColor = Colors.orange;
        break;
      case 'Accepted':
        ringColor = Colors.blue;
        textColor = Colors.blue;
        break;
      case 'Completed':
        ringColor = Colors.green;
        textColor = Colors.green;
        break;
      default:
        ringColor = Colors.grey;
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: ringColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons(String status, int index) {
    if (status == 'Completed') {
      return const SizedBox.shrink();
    }

    if (status == 'Pending') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
              child: const Text('Decline', style: TextStyle(color: Colors.red)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateOrderStatus(index, 'Accepted'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Accept'),
            ),
          ),
        ],
      );
    }

    if (status == 'Accepted') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateOrderStatus(index, 'Completed'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Complete Delivery'),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

void main() {
  runApp(const MaterialApp(
    home: DriverOrdersPage(),
    debugShowCheckedModeBanner: false,
  ));
}
