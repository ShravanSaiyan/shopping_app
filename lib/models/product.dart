import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  Product(
      {this.id = "",
      this.title = "",
      this.description = "",
      this.price = 0.0,
      this.imageUrl = "",
      this.isFavorite = false});

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite}';
  }

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
