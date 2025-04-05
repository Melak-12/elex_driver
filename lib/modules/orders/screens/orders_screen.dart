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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      context.read<OrderProvider>().searchOrders(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search Pending Orders',
                      hintStyle: TextStyle(color: AppColors.primary),
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
      child: ExpansionTile(
        leading: const Icon(Icons.gas_meter_outlined),
        title: Text(
          order.invoice,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(order.orderType),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            order.status,
            style: const TextStyle(
              color: Colors.green,
            ),
          ),
        ),
        children: [
          _buildListTile(Icons.account_circle_rounded, "Customer ID",
              order.customerId.toString()),
          _buildListTile(Icons.location_on, "From", order.pickupLocation),
          _buildListTile(Icons.location_on, "To", order.deliveryStreetAddress),
          _buildListTile(Icons.phone, "Phone", order.contactNumber),
          _buildListTile(Icons.timer, "Time", order.orderTime.toString()),
          _buildListTile(Icons.monetization_on, "Amount", "\$${order.amount}"),
          _buildListTile(
              Icons.info_outline, "Instructions", order.specialInstructions),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.primary,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary2,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.primary2)),
              Text(subtitle, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
