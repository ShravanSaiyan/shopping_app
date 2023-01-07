import 'package:flutter/material.dart';
import 'package:shopping_app/models/cart.dart';

class OrderItem {
  final String orderItemId;
  final double price;
  final DateTime date;
  final List<CartItem> products;

  OrderItem(
      {required this.orderItemId,
      required this.price,
      required this.date,
      required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orderItems = [];

  List<OrderItem> get orderItems {
    return [..._orderItems];
  }

  void addOrder(List<CartItem> cartProducts, double totalAmount) {
    _orderItems.insert(
        0,
        OrderItem(
            orderItemId: DateTime.now().toString(),
            price: totalAmount,
            date: DateTime.now(),
            products: cartProducts));
    notifyListeners();
  }
}
