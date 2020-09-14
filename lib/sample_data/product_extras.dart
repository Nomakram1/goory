import 'package:flutter/foundation.dart';
import 'package:foodie/data/models/food_extra.dart';

class FoodExtras {
  //all sample food options
  static List<ProductExtra> productsExtras({@required int productId}) {
    List<ProductExtra> options = [];

    var mFoodExtra = ProductExtra(
      //just trying to generate a unique id for the food option
      //this should be your food option id from your backend
      id: productId + 1,
      productId: productId,
      name: "Large",
      price: 0,
    );
    options.add(mFoodExtra);

    mFoodExtra = ProductExtra(
      //just trying to generate a unique id for the food option
      //this should be your food option id from your backend
      id: productId + 2,
      productId: productId,
      name: "Medium",
      price: 0,
    );
    options.add(mFoodExtra);

    mFoodExtra = ProductExtra(
      //just trying to generate a unique id for the food option
      //this should be your food option id from your backend
      id: productId + 3,
      productId: productId,
      name: "Small",
      price: 0,
    );
    options.add(mFoodExtra);

    //so you dont have same arrangment twice
    options.shuffle();
    return options;
  }

  static List<ProductExtra> varientFoodExtras({@required int foodId}) {
    List<ProductExtra> options = [];

    var mFoodExtra = ProductExtra(
      //just trying to generate a unique id for the food option
      //this should be your food option id from your backend
      id: foodId + 11,
      productId: foodId,
      name: "With Cream",
      price: 0,
    );
    options.add(mFoodExtra);

    mFoodExtra = ProductExtra(
      //just trying to generate a unique id for the food option
      //this should be your food option id from your backend
      id: foodId + 12,
      productId: foodId,
      name: "With Extra Milk",
      price: 0,
    );
    options.add(mFoodExtra);

    mFoodExtra = ProductExtra(
      //just trying to generate a unique id for the food option
      //this should be your food option id from your backend
      id: foodId + 13,
      productId: foodId,
      name: "With Honey",
      price: 0,
    );
    options.add(mFoodExtra);

//so you dont have same arrangment twice
    options.shuffle();
    return options;
  }
}
