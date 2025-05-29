import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:elex_driver/modules/home/models/home_model.dart';
import 'package:elex_driver/modules/home/providers/home_provider.dart';
import 'package:elex_driver/modules/home/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:live_indicator/live_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchNewOrder();
    });
  }

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
            'Home',
            style: AppTextStyles.headline2,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<HomeProvider>().fetchNewOrder();
              },
            ),
                 IconButton(
              onPressed: () {
                final notificationProvider =
                    context.read<NotificationProvider>();
                notificationProvider.showNotification(
                  title: "New Order Alert",
                  body: "You Got new order !",
                  
                );
              },
              icon: const Icon(
                Icons.notifications_none,
                size: 30,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  if (provider.isLoading)
                    const Center(
                      child: CupertinoActivityIndicator(
                        radius: 20,
                        color: AppColors.primary,
                      ),
                    )
                  else if (provider.incomingOrders.isNotEmpty)
                    _buildOrderCard(provider.incomingOrders.first, provider)
                  else
                    _buildEmptyState(provider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(HomeProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
     
          // IconButton(
          //   onPressed: () => {
          //     debugPrint('\x1B[32mnotification pressed\x1B[0m'),
          //   },
          //   icon: const Icon(
          //     Icons.notifications_none,
          //     size: 60,
          //     color: AppColors.primary,
          //   ),
          // ),
          
          const SizedBox(height: 16),
          const Text(
            'Waiting for orders',
            style: AppTextStyles.headline3,
          ),
          const SizedBox(height: 8),
          const Text(
            'You will be notified when a new order arrives',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.fetchNewOrder(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Check for orders',
              style: AppTextStyles.buttonText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(IncomingOrder order, HomeProvider provider) {
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 6),

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
          // Order header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.gas_meter_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.id.split('-').first,
                        style: AppTextStyles.headline3,
                      ),
                      const Text(
                        "Delivery Request",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                _buildOrderStatus(order.createdAt),
              ],
            ),
          ),

          const Divider(),

          // Order details
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
            child: Column(
              children: [
                _buildDetailRow(Icons.account_circle_rounded, "Customer",
                    order.customerName),
                _buildDetailRow(
                    Icons.location_on, "From", order.pickupLocation),
                _buildDetailRow(Icons.location_on, "To", order.dropoffLocation),
                _buildDetailRow(
                    Icons.phone, "Phone", order.customerPhone ?? "N/A"),
                _buildDetailRow(
                    Icons.payments, "Amount", "${order.amount} ETB"),
                if (order.orderNote != null && order.orderNote!.isNotEmpty)
                  _buildDetailRow(Icons.note, "Note", order.orderNote!),
              ],
            ),
          ),

          // Action button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => provider.acceptOrder(order.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary2,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Complete',
                style: AppTextStyles.buttonText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus(DateTime createdAt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amber[900]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'New',
            style: AppTextStyles.bodyText1.copyWith(
              color: Colors.amber[900],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatTime(createdAt),
          style: AppTextStyles.bodyText1,
        )
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodyText1.copyWith(
                    color: AppColors.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyText2,
                ),
              ],
            ),
          ),
        ],
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arada, Addis Ababa',
                        style: AppTextStyles.bodyText1.copyWith(
                          color: Colors.white,
                        ),
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
}
