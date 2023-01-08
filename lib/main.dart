import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/cart.dart';
import 'package:shopping_app/models/order.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/edit_user_product_screen.dart';
import 'package:shopping_app/screens/orders_screen.dart';
import 'package:shopping_app/screens/product_detail.dart';
import 'package:shopping_app/screens/product_overview.dart';
import 'package:shopping_app/screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders()),
      ],
      child: MaterialApp(
        title: 'Shopping App',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            colorScheme: const ColorScheme.light(secondary: Colors.deepOrange),
            fontFamily: "Lato"),
        home: const ProductOverview(),
        routes: {
          ProductDetail.routeName: (_) => const ProductDetail(),
          CartScreen.routeName: (_) => const CartScreen(),
          OrdersScreen.routeName: (_) => const OrdersScreen(),
          UserProductScreen.routeName: (_) => const UserProductScreen(),
          EditUserProductScreen.routeName: (_) => const EditUserProductScreen()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
