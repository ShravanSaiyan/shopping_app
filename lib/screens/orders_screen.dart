import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/order.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/order_item_builder.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: ListView.builder(
          itemCount: orderData.orderItems.length,
          itemBuilder: (_, index) =>
              OrderItemBuilder(orderItem: orderData.orderItems[index])),
    );
  }
}
