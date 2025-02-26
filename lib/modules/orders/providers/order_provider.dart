import 'package:elex_driver/modules/orders/models/order_model.dart';
import 'package:flutter/foundation.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  Order? _currentOrder;

  List<Order> get orders => _orders;
  Order? get currentOrder => _currentOrder;

  Future<void> fetchOrders() async {
    notifyListeners();
  }

  void acceptOrder(Order order) {
    _currentOrder = order;
    notifyListeners();
  }
}
