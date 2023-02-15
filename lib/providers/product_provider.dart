import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  String? authToken;

  ProductProvider(this.authToken);

  final List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get getOnlyFavoriteProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  Product findByProductId(String productId) {
    return _products.firstWhere((element) => element.id == productId);
  }

  Future<void> getProducts() async {
    var url = Uri.parse(
        "https://shopping-app-flutter-3ea73-default-rtdb.firebaseio.com/product.json?auth=$authToken");

    try {
      await http.get(url);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        "https://shopping-app-flutter-3ea73-default-rtdb.firebaseio.com/product.json?auth=$authToken");
    try {
      var response = await http.post(url, body: jsonEncode(product));
      product.id = jsonDecode(response.body)["name"];
      _products.add(product);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) {
    var existingProductIndex = _products
        .indexWhere((existingProduct) => existingProduct.id == product.id);
    if (existingProductIndex == -1) {
      return addProduct(product);
    }
    _products[existingProductIndex] = product;
    notifyListeners();
    return Future.value();
  }

  void deleteProduct(String id) {
    _products.removeWhere((existingProduct) => existingProduct.id == id);
    notifyListeners();
  }
}
