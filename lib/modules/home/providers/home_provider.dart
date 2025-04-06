import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:elex_driver/modules/home/models/home_model.dart';

class HomeProvider with ChangeNotifier {
  Timer? _orderTimer;
  List<IncomingOrder> _incomingOrders = [];
  bool _isLoading = false;
  String? _error;
  int _currentOrderIndex = 0;
  final Set<String> _notifiedOrderIds = {};

  List<IncomingOrder> get incomingOrders => _incomingOrders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  HomeProvider() {
    _startOrderTimer();
  }

  void _startOrderTimer() {
    // First fetch immediately
    fetchNewOrder();

    // Then set up timer for every 30 seconds (for demo purposes)
    _orderTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      // Only fetch a new order if there are none currently
      if (_incomingOrders.isEmpty) {
        fetchNewOrder();
      }
    });
  }

  Future<void> fetchNewOrder() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Load sample orders from JSON file
      final String response =
          await rootBundle.loadString('assets/jsons/orders_incoming.json');
      final List<dynamic> ordersJson = json.decode(response);

      // Check if we have any orders in the JSON
      if (ordersJson.isEmpty) {
        _error = 'No orders available';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Get next order in sequence (cycling through the available orders)
      final Map<String, dynamic> orderJson =
          ordersJson[_currentOrderIndex % ordersJson.length];
      _currentOrderIndex++;

      // Create order from JSON
      final newOrder = IncomingOrder.fromJson(orderJson);

      // Update current time to make it feel like a new order
      final updatedOrder = IncomingOrder(
        id: '${newOrder.id}-${DateTime.now().millisecondsSinceEpoch}',
        customerName: newOrder.customerName,
        pickupLocation: newOrder.pickupLocation,
        dropoffLocation: newOrder.dropoffLocation,
        amount: newOrder.amount,
        status: 'pending',
        createdAt: DateTime.now(),
        customerPhone: newOrder.customerPhone,
        customerImage: newOrder.customerImage,
        orderNote: newOrder.orderNote,
      );

      // Only add the new order if there are none currently
      // This ensures we only have one order at a time
      if (_incomingOrders.isEmpty) {
        _incomingOrders = [updatedOrder];
        _notifiedOrderIds.add(updatedOrder.id);
      }

      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch new order: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _incomingOrders =
          _incomingOrders.where((order) => order.id != orderId).toList();

      // Remove from notified list as well
      _notifiedOrderIds.remove(orderId);

      notifyListeners();
    } catch (e) {
      _error = 'Failed to accept order: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> rejectOrder(String orderId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _incomingOrders =
          _incomingOrders.where((order) => order.id != orderId).toList();

      // Remove from notified list as well
      _notifiedOrderIds.remove(orderId);

      notifyListeners();
    } catch (e) {
      _error = 'Failed to reject order: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _orderTimer?.cancel();
    super.dispose();
  }
}
