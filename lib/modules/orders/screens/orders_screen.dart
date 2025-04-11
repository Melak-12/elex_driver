import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:elex_driver/modules/orders/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:live_indicator/live_indicator.dart';
import 'package:provider/provider.dart';
import 'package:elex_driver/modules/orders/models/order_model.dart';
import 'package:flutter/cupertino.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderProvider>().fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/images/Logo.png',
            width: 20,
            height: 20,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: AppColors.appBarColor,
        title: const Text(
          'Delivery Orders',
          style: AppTextStyles.headline2,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(
              child: Selector<OrderProvider, bool>(
                selector: (_, provider) => provider.isLoading,
                builder: (context, isLoading, child) {
                  if (isLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(
                        radius: 20,
                        color: AppColors.primary,
                      ),
                    );
                  }
                  return child!;
                },
                child: Selector<OrderProvider, String?>(
                  selector: (_, provider) => provider.error,
                  builder: (context, error, child) {
                    if (error != null) {
                      return Center(child: Text(error));
                    }
                    return child!;
                  },
                  child: Selector<OrderProvider, List<Order>>(
                    selector: (_, provider) => provider.orders,
                    builder: (context, orders, child) {
                      if (orders.isEmpty) {
                        return const Center(child: Text('No orders found'));
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          await context.read<OrderProvider>().fetchOrders();
                        },
                        color: AppColors.primary,
                        backgroundColor: Colors.white,
                        strokeWidth: 2.0,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return _buildOrderCard(order);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
                          spreadDuration: const Duration(microseconds: 100),
                          waitDuration: const Duration(milliseconds: 500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arada, Addis Ababa',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              StreamBuilder<DateTime>(
                stream: Stream.periodic(
                    const Duration(seconds: 1), (_) => DateTime.now()),
                builder: (context, snapshot) {
                  final now = snapshot.data ?? DateTime.now();
                  final hour = now.hour > 12
                      ? now.hour - 12
                      : (now.hour == 0 ? 12 : now.hour);
                  final amPm = now.hour >= 12 ? 'PM' : 'AM';
                  final formattedTime =
                      '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')} $amPm';
                  return Text(
                    formattedTime,
                    style: AppTextStyles.bodyText1.copyWith(
                      color: Colors.white,
                    ),
                  );
                },
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      context.read<OrderProvider>().searchOrders(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Pending Orders',
                      hintStyle: AppTextStyles.bodyText1.copyWith(
                        color: AppColors.primary,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Icon(Icons.search),
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
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.gas_meter_outlined),
        title: Text(
          order.invoice,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          order.orderType,
          style: AppTextStyles.bodyText1,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(
              color: order.status == "Completed"
                  ? Colors.green
                  : order.status == "Rejected"
                      ? Colors.red
                      : order.status == "Pending"
                          ? Colors.amber
                          : Colors.green,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            order.status,
            style: AppTextStyles.bodyText2.copyWith(
              color: order.status == "Completed"
                  ? Colors.green
                  : order.status == "Rejected"
                      ? Colors.red
                      : order.status == "Pending"
                          ? Colors.amber
                          : Colors.green,
           fontSize: 12 ),
          ),
        ),
        onTap: () {
          _showOrderDetails(context, order);
        },
      ),
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Status badge at top right
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: order.status == "Completed"
                          ? Colors.green
                          : order.status == "Rejected"
                              ? Colors.red
                              : order.status == "Pending"
                                  ? Colors.amber
                                  : Colors.green,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      order.status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                      ),
                    ),
                    Text(
                      order.invoice,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary2),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(Icons.account_circle_rounded, "Customer ID",
                        order.customerId.toString()),
                    _buildDetailRow(
                        Icons.location_on, "From", order.pickupLocation),
                    _buildDetailRow(
                        Icons.location_on, "To", order.deliveryStreetAddress),
                    _buildDetailRow(Icons.phone, "Phone", order.contactNumber),
                    _buildDetailRow(
                        Icons.timer, "Time", order.orderTime.toString()),
                    _buildDetailRow(
                        Icons.monetization_on, "Amount", "\$${order.amount}"),
                    _buildDetailRow(Icons.info_outline, "Instructions",
                        order.specialInstructions),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigate to map with this order location
                            context.pop();
                            context.push('/map');
                          },
                          icon: const Icon(Icons.map, color: Colors.white),
                          label: const Text('View on Map',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        if (order.status == "Pending")
                          ElevatedButton.icon(
                            onPressed: () {
                              // Accept order logic
                              context.pop();
                            },
                            icon: const Icon(Icons.check_circle,
                                color: Colors.white),
                            label: const Text('Accept',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyText1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
