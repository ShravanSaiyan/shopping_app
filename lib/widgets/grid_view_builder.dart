import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/screens/product_detail.dart';
import 'package:shopping_app/widgets/product_item.dart';

class GridViewBuilder extends StatelessWidget {
  final bool isFavorite;

  const GridViewBuilder({Key? key, required this.isFavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final products = isFavorite
        ? productsData.getOnlyFavoriteProducts
        : productsData.products;
    return GridView.builder(
        itemCount: products.length,
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 3 / 2),
        itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetail.routeName,
                    arguments: products[index].id);
              },
              child: ChangeNotifierProvider.value(
                value: products[index],
                child: const ProductItem(),
              ),
            ));
  }
}
