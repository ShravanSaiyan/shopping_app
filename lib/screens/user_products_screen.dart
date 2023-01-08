import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product_provider.dart';
import 'package:shopping_app/screens/add_or_edit_user_product_screen.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/user_product_builder.dart';

class UserProductScreen extends StatelessWidget {
  static const String routeName = "/user-products";

  const UserProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context).products;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddOrEditUserProductScreen.routeName,
                    arguments: {"title": "Add Products"});
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: productsData.length,
            itemBuilder: (_, index) => Column(
                  children: [
                    UserProductBuilder(
                      id: productsData[index].id,
                      title: productsData[index].title,
                      imageUrl: productsData[index].imageUrl,
                    ),
                    const Divider()
                  ],
                )),
      ),
    );
  }
}
