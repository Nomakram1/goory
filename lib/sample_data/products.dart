import 'package:foodie/data/models/product.dart';
import 'package:foodie/sample_data/product_extras.dart';

class Products {
  //all sample products
  static List<Product> availableProducts() {
    List<Product> products = [];

    var mFood = Product(
      id: 1,
      name: "Waffle",
      price: 20.50,
      photoUrl:
          "https://storcpdkenticomedia.blob.core.windows.net/media/recipemanagementsystem/media/recipe-media-files/recipes/retail/x17/2020_belgian-style-waffles_16700_760x580.jpg?ext=.jpg",
      description:
          "He wondered if he should disclose the truth to his friends. It would be a risky move. Yes, the truth would make things a lot easier if they all stayed on the same page, but the truth might fracture the group leaving everything in even more of a mess than it was not telling the truth. It was time to decide which way to go. Where do they get a random paragraph? he wondered as he clicked the generate button. Do they just write a random paragraph or do they get it somewhere? At that moment he read the random paragraph and realized it was about random paragraphs and his world would never be the same.",
      extras: FoodExtras.productsExtras(productId: 1),
    );
    products.add(mFood);

    mFood = Product(
      id: 2,
      name: "Ice cream",
      price: 10.50,
      photoUrl:
          "https://img.taste.com.au/s1jxJX_d/taste/2017/12/roasted-peach-sour-cream-ice-cream-taste_1980x1320-133837-1.jpg",
      description:
          "Pink ponies and purple giraffes roamed the field. Cotton candy grew from the ground as a chocolate river meandered off to the side. What looked like stones in the pasture were actually rock candy. Everything in her dream seemed to be perfect except for the fact that she had no mouth.",
      extras: FoodExtras.varientFoodExtras(foodId: 2),
    );
    products.add(mFood);

    mFood = Product(
      id: 3,
      name: "Fried Chicken",
      price: 5.00,
      photoUrl:
          "https://www.oliviascuisine.com/wp-content/uploads/2019/10/fried-chicken-thumb-735x735.jpg",
      description:
          "Pink ponies and purple giraffes roamed the field. Cotton candy grew from the ground as a chocolate river meandered off to the side. What looked like stones in the pasture were actually rock candy. Everything in her dream seemed to be perfect except for the fact that she had no mouth.",
      extras: FoodExtras.productsExtras(productId: 3),
    );
    products.add(mFood);

    mFood = Product(
      id: 4,
      name: "Salad",
      price: 3.50,
      photoUrl:
          "https://www.onceuponachef.com/images/2019/07/Big-Italian-Salad-1200x1553.jpg",
      description:
          "Pink ponies and purple giraffes roamed the field. Cotton candy grew from the ground as a chocolate river meandered off to the side. What looked like stones in the pasture were actually rock candy. Everything in her dream seemed to be perfect except for the fact that she had no mouth.",
      extras: FoodExtras.varientFoodExtras(foodId: 4),
    );
    products.add(mFood);

    mFood = Product(
      id: 5,
      name: "Guacamole",
      price: 15.50,
      photoUrl:
          "https://www.jessicagavin.com/wp-content/uploads/2019/04/guacamole-6-1200.jpg",
      description:
          "Pink ponies and purple giraffes roamed the field. Cotton candy grew from the ground as a chocolate river meandered off to the side. What looked like stones in the pasture were actually rock candy. Everything in her dream seemed to be perfect except for the fact that she had no mouth.",
      extras: FoodExtras.productsExtras(productId: 5),
    );
    products.add(mFood);

    mFood = Product(
      id: 6,
      name: "Steakhouse Burger",
      price: 15.50,
      photoUrl:
          "https://mystarchefs.com/wp-content/uploads/2018/09/Why-Burgers-are-the-Most-Popular-Fast-Product.jpg",
      description:
          "Pink ponies and purple giraffes roamed the field. Cotton candy grew from the ground as a chocolate river meandered off to the side. What looked like stones in the pasture were actually rock candy. Everything in her dream seemed to be perfect except for the fact that she had no mouth.",
      extras: FoodExtras.varientFoodExtras(foodId: 6),
    );
    products.add(mFood);
    return products;
  }
}
