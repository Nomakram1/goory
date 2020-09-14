import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/sample_data/menus.dart';
import 'package:random_string/random_string.dart';

class Vendors {
  //all sample vendors
  static List<Vendor> _stores() {
    List<Vendor> vendors = [];
    //generate a unqiue code for hero tag, to avoid "there are multiple heroes that share the same tag within a subtree"
    final heroTag = randomAlphaNumeric(10);

    var mStore = Vendor(
      name: "The Honeysuckle Pub & Restaurant (Osu)",
      slug: "honey-suckle-$heroTag",
      address: "Lapaz, Accra, Ghana",
      featureImage:
          "https://media-cdn.tripadvisor.com/media/photo-s/18/1a/d5/1e/casteloes.jpg",
      categories: "Chicken • Burgers • Continnental • Drinks",
      minimumDeliveryTime: 50,
      maxmumDeliveryTime: 90,
      menus: Menus.availableMenus(),
    );
    vendors.add(mStore);

    mStore = Vendor(
      name: "KFC (Osu)",
      slug: "kfc-osu-$heroTag",
      address: "Lapaz, Accra, Ghana",
      featureImage:
          "https://cdn-a.william-reed.com/var/wrbm_gb_food_pharma/storage/images/publications/food-beverage-nutrition/foodnavigator.com/article/2020/04/21/fodmap-could-enzymes-help-boost-tolerability-in-plant-based-foods/10928071-1-eng-GB/FODMAP-Could-enzymes-help-boost-tolerability-in-plant-based-foods_wrbm_large.jpg",
      categories: "Chicken • Burgers • Drinks",
      minimumDeliveryTime: 30,
      maxmumDeliveryTime: 120,
      menus: Menus.availableMenus(),
    );
    vendors.add(mStore);

    mStore = Vendor(
      name: "KC Fruits",
      slug: "kc-fruits-$heroTag",
      address: "Lapaz, Accra, Ghana",
      featureImage:
          "https://post.healthline.com/wp-content/uploads/sites/3/2020/02/322284_2200-1200x628.jpg",
      categories: "Chicken • Drinks",
      minimumDeliveryTime: 20,
      maxmumDeliveryTime: 80,
      menus: Menus.availableMenus(),
    );
    vendors.add(mStore);

    mStore = Vendor(
      name: "Pious Foods",
      slug: "pious-foods-$heroTag",
      address: "Lapaz, Accra, Ghana",
      featureImage:
          "https://food-images.files.bbci.co.uk/food/recipes/jollof_rice_with_chicken_74636_16x9.jpg",
      categories: "Burgers • Continnental • Drinks",
      minimumDeliveryTime: 40,
      maxmumDeliveryTime: 60,
      menus: Menus.availableMenus(),
    );
    vendors.add(mStore);

    mStore = Vendor(
      name: "ZooZoo Restaurant",
      slug: "zoozoo-resturant-$heroTag",
      address: "Lapaz, Accra, Ghana",
      featureImage:
          "https://cdn.vox-cdn.com/thumbor/73nhsZwI55BVgH8-rapmIhkvbUk=/0x0:4047x3035/1200x675/filters:focal(1700x1194:2346x1840)/cdn.vox-cdn.com/uploads/chorus_image/image/64046617/20150915-_Upland_Burger_3.0.0.1489236245.0.jpg",
      categories: "Burgers • Continnental",
      minimumDeliveryTime: 20,
      maxmumDeliveryTime: 80,
      menus: Menus.availableMenus(),
    );
    vendors.add(mStore);

    return vendors;
  }

//generate vendors in random order
  static List<Vendor> randomStores({
    int maxSize = 0,
  }) {
    List<Vendor> vendors = _stores();
    vendors.shuffle();
    if (maxSize > 0) {
      return vendors.sublist(0, maxSize);
    }
    return vendors;
  }
}
