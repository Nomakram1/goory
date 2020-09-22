import 'package:Doory/data/models/menu.dart';
import 'package:Doory/sample_data/products.dart';

class Menus {
  //all sample menus
  static List<Menu> availableMenus() {
    List<Menu> menus = [];
    final mFoods = Products.availableProducts();

    //shuffle the food list to avoid same arrangement like the previous one
    mFoods.shuffle();
    var mMenu = Menu(
      name: "Breakfast",
      products: mFoods,
    );
    menus.add(mMenu);

    //shuffle the food list to avoid same arrangement like the previous one
    mFoods.shuffle();
    mMenu = Menu(
      name: "Lunch",
      products: mFoods,
    );
    menus.add(mMenu);

    //shuffle the food list to avoid same arrangement like the previous one
    mFoods.shuffle();
    mMenu = Menu(
      name: "Dinner",
      products: mFoods,
    );
    menus.add(mMenu);

    //shuffle the food list to avoid same arrangement like the previous one
    mFoods.shuffle();
    mMenu = Menu(
      name: "Office",
      products: mFoods,
    );
    menus.add(mMenu);

    //shuffle the food list to avoid same arrangement like the previous one
    mFoods.shuffle();
    mMenu = Menu(
      name: "Burgers",
      products: mFoods,
    );
    menus.add(mMenu);

    return menus;
  }
}
