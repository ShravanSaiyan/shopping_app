import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/cart.dart';
import 'package:shopping_app/models/order.dart';
import 'package:shopping_app/providers/auth_provider.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/screens/add_or_edit_user_product_screen.dart';
import 'package:shopping_app/screens/authentication_screen.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/screens/orders_screen.dart';
import 'package:shopping_app/screens/product_detail.dart';
import 'package:shopping_app/screens/product_overview.dart';
import 'package:shopping_app/screens/splash_screen.dart';
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
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProxyProvider<AuthenticationProvider, ProductProvider>(
            create: (_) => ProductProvider(""),
            update: (ctx, auth, previousProducts) =>
                ProductProvider(auth.token)),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders()),
      ],
      child: Consumer<AuthenticationProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Shopping App',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              colorScheme:
                  const ColorScheme.light(secondary: Colors.deepOrange),
              fontFamily: "Lato"),
          home: auth.isAuth
              ? const ProductOverview()
              : FutureBuilder(
                  future: auth.isAutoLogin(),
                  builder: (ctx, authResult) =>
                      authResult.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthenticationScreen()),
          routes: {
            ProductDetail.routeName: (_) => const ProductDetail(),
            CartScreen.routeName: (_) => const CartScreen(),
            OrdersScreen.routeName: (_) => const OrdersScreen(),
            UserProductScreen.routeName: (_) => const UserProductScreen(),
            AddOrEditUserProductScreen.routeName: (_) =>
                const AddOrEditUserProductScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
