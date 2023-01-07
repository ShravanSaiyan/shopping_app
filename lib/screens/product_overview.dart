import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/cart.dart';
import 'package:shopping_app/screens/cart_screen.dart';
import 'package:shopping_app/widgets/app_drawer.dart';

import '../widgets/badge.dart';
import '../widgets/grid_view_builder.dart';

enum FilterOptions { favorites, all }

class ProductOverview extends StatefulWidget {
  static const routeName = "/product-overview";

  const ProductOverview({Key? key}) : super(key: key);

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping"),
        actions: [
          PopupMenuButton(
              onSelected: (selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showFavorites = true;
                  } else {
                    _showFavorites = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.favorites,
                      child: Text("Favorites"),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.all,
                      child: Text("Show All"),
                    )
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(value: cart.cartItemsCount.toString(), child: ch!),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: GridViewBuilder(isFavorite: _showFavorites),
      drawer: const AppDrawer(),
    );
  }
}
