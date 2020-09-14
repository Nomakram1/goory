import 'package:flutter/foundation.dart';
import 'package:foodie/data/models/product.dart';

class Menu {
  int id;
  String name;
  List<Product> products;

  Menu({
    this.id,
    this.name,
    this.products,
  });

  factory Menu.fromJSON({
    @required jsonObject,
    int vendorId,
  }) {
    final menu = Menu();
    menu.name = jsonObject["name"];

    //load products
    final productsJSONArray = (jsonObject["products"] as List);
    menu.products = productsJSONArray.map(
      (foodJSONObject) {
        final mFood = Product.fromJSON(
          jsonObject: foodJSONObject,
        );
        mFood.vendorId = vendorId;
        return mFood;
      },
    ).toList();
    return menu;
  }
}
