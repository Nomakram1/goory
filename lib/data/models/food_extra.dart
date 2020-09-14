import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

@Entity(
  tableName: "product_extras",
)
class ProductExtra {
  @primaryKey
  int id;
  int productId;
  double price;
  String name;
  String photo;

  ProductExtra({
    this.id,
    this.productId,
    this.price = 0,
    this.name,
    this.photo,
  });

  factory ProductExtra.fromJSON({
    @required jsonObject,
  }) {
    final productExtra = ProductExtra();
    productExtra.id = jsonObject["id"];
    productExtra.name = jsonObject["name"];
    productExtra.photo = jsonObject["photo"] ?? "";
    productExtra.price = double.parse(
      jsonObject["price"].toString(),
    );
    return productExtra;
  }
}
