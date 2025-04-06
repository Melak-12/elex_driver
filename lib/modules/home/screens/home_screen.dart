import 'package:elex_driver/core/constants/colors/colors.dart';
import 'package:elex_driver/core/constants/text_styles.dart';
import 'package:elex_driver/modules/home/models/home_model.dart';
import 'package:elex_driver/modules/home/providers/home_provider.dart';
import 'package:elex_driver/modules/orders/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import "package:live_indicator/live_indicator.dart";
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Trigger animation when a new order arrives
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<HomeProvider>(context, listen: false);
      provider.addListener(_onOrdersChanged);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    Provider.of<HomeProvider>(context, listen: false)
        .removeListener(_onOrdersChanged);
    super.dispose();
  }

  void _onOrdersChanged() {
    if (mounted) {
      _animationController.reset();
      _animationController.forward();
    }
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
          ],
        ),
        body: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: SafeArea(
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              const Spacer(),
                              StreamBuilder<DateTime>(
                                stream: Stream.periodic(
                                    const Duration(seconds: 1),
                                    (_) => DateTime.now()),
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
                                    style: const TextStyle(color: Colors.white),
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
                                      context
                                          .read<OrderProvider>()
                                          .searchOrders(value);
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Search Pending Orders',
                                      hintStyle:
                                          TextStyle(color: AppColors.primary),
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
                    ),
                    const SizedBox(height: 30),

                    // Show newest incoming order if available
                    if (provider.incomingOrders.isNotEmpty)
                      _buildOrderCard(provider.incomingOrders.first, provider),

                    // Show waiting message if no orders
                    if (provider.incomingOrders.isEmpty && !provider.isLoading)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
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
                            const Icon(
                              Icons.notifications_none,
                              size: 60,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Waiting for orders',
                              style: AppTextStyles.headline3,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'You will be notified when a new order arrives',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                provider.fetchNewOrder();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
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
                      ),

                    // Show loading indicator
                    if (provider.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CupertinoActivityIndicator(
                            radius: 20,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(IncomingOrder order, HomeProvider provider) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.1),
        end: Offset.zero,
      ).animate(_animation),
      child: FadeTransition(
        opacity: _animation,
        child: Container(
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
              Stack(
                children: [
                  ListTile(
                    leading: const Icon(Icons.gas_meter_outlined),
                    title: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.id.split('-').first,
                        style: AppTextStyles.headline3,
                      ),
                    ),
                    subtitle: const Text(
                      "Delivery Request",
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
                            'New',
                            style: TextStyle(
                              color: Colors.amber[900],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _formatTime(order.createdAt),
                        )
                      ],
                    ),
                  ),
                  if (_isNewOrder(order))
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    _buildListRow(
                        Icons.account_circle_rounded, order.customerName),
                    _buildListRow(
                        Icons.location_on, "From", order.pickupLocation),
                    _buildListRow(
                        Icons.location_on, "To", order.dropoffLocation),
                    _buildListRow(
                        Icons.phone, "Phone", order.customerPhone ?? "N/A"),
                    _buildListRow(
                        Icons.payments, "Amount", "${order.amount} ETB"),
                    if (order.orderNote != null)
                      _buildListRow(Icons.note, "Note", order.orderNote!),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Expanded(
                          //   child: ElevatedButton(
                          //     onPressed: () => provider.rejectOrder(order.id),
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.red,
                          //       padding:
                          //           const EdgeInsets.symmetric(vertical: 12),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8),
                          //       ),
                          //     ),
                          //     child: const Text(
                          //       'Reject',
                          //       style: AppTextStyles.buttonText,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => provider.acceptOrder(order.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary2,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Complete',
                                style: AppTextStyles.buttonText,
                              ),
                            ),
                          ),
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
    );
  }

  bool _isNewOrder(IncomingOrder order) {
    // Consider an order new if it's less than 1 minute old
    return DateTime.now().difference(order.createdAt).inMinutes < 1;
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
