import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/cart.dart';
import 'package:shopping_app/models/order.dart';
import 'package:shopping_app/widgets/cart_item_builder.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.cartItems.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      "\$${cart.totalAmount}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.cartItemsCount,
                  itemBuilder: (_, index) => CartItemBuilder(
                      productId: cart.cartItems.keys.toList()[index],
                      id: cartItems[index].cartId,
                      price: cartItems[index].price,
                      title: cartItems[index].title,
                      quantity: cartItems[index].quantity))),
          ElevatedButton(
            onPressed: () {
              Provider.of<Orders>(context, listen: false)
                  .addOrder(cartItems, cart.totalAmount);
              cart.clearCart();
            },
            style: const ButtonStyle(alignment: Alignment.center),
            child: const Text("ORDER NOW"),
          )
        ],
      ),
    );
  }
}
