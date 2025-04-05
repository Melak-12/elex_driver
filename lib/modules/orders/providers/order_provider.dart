import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:elex_driver/modules/orders/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  Order? _currentOrder;
  bool _isLoading = false;
  String? _error;

  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Order> get pendingOrders =>
      _orders.where((order) => order.status == 'Pending').toList();
  List<Order> get completedOrders =>
      _orders.where((order) => order.status == 'Completed').toList();

  Future<void> fetchOrders() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Load the JSON file from assets
      final String response =
          await rootBundle.loadString('assets/jsons/orders.json');
      final data = await json.decode(response);

      if (data['success'] == true && data['data'] != null) {
        _orders =
            (data['data'] as List).map((json) => Order.fromJson(json)).toList();
      } else {
        _error = 'Failed to load orders';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void acceptOrder(Order order) {
    _currentOrder = order;
    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      // In a real app, you would make an API call here
      // For now, we'll just update the local state
      _orders[index] = order;
    }
    notifyListeners();
  }

  void searchOrders(String query) {
    if (query.isEmpty) {
      fetchOrders();
      return;
    }

    _orders = _orders
        .where((order) =>
            order.invoice.toLowerCase().contains(query.toLowerCase()) ||
            order.orderType.toLowerCase().contains(query.toLowerCase()) ||
            order.status.toLowerCase().contains(query.toLowerCase()) ||
            order.cylinderType.toLowerCase().contains(query.toLowerCase()))
        .toList();

    notifyListeners();
  }
}
