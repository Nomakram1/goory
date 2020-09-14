import 'package:foodie/data/models/order.dart';
import 'package:random_string/random_string.dart';

class Orders {
  //all sample vendors
  static List<Order> _orders() {
    List<Order> orders = [];

    var mOrder = Order(
      id: 1,
      code: randomAlphaNumeric(10),
      date: "6 Jul, 2020",
      // photoUrl: "https://media-cdn.tripadvisor.com/media/photo-s/18/1a/d5/1e/casteloes.jpg",
      totalAmount: 20.40,
      status: "Pending",
    );
    orders.add(mOrder);

    mOrder = Order(
      id: 1,
      code: randomAlphaNumeric(10),
      date: "5 Jul, 2020",
      // photoUrl: "https://media-cdn.tripadvisor.com/media/photo-s/18/1a/d5/1e/casteloes.jpg",
      totalAmount: 20.40,
      status: "Cancelled",
    );
    orders.add(mOrder);

    mOrder = Order(
      id: 1,
      code: randomAlphaNumeric(10),
      date: "5 Jul, 2020",
      // photoUrl: "https://media-cdn.tripadvisor.com/media/photo-s/18/1a/d5/1e/casteloes.jpg",
      totalAmount: 20.40,
      status: "Delivered",
    );
    orders.add(mOrder);

    mOrder = Order(
      id: 1,
      code: randomAlphaNumeric(10),
      date: "7 Jul, 2020",
      // photoUrl: "https://media-cdn.tripadvisor.com/media/photo-s/18/1a/d5/1e/casteloes.jpg",
      totalAmount: 20.40,
      status: "Delivered",
    );
    orders.add(mOrder);

    return orders;
  }

//generate orders in random order
  static List<Order> randomOrders({
    int maxSize = 0,
  }) {
    List<Order> orders = _orders();
    orders.shuffle();
    if (maxSize > 0) {
      return orders.sublist(0, maxSize);
    }
    return orders;
  }
}
