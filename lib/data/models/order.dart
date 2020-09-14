import 'package:foodie/data/models/currency.dart';
import 'package:foodie/data/models/deliver_address.dart';
import 'package:foodie/data/models/payment_option.dart';
import 'package:foodie/data/models/product.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:intl/intl.dart';

class Order {
  int id;
  String code;
  String date;
  String status;
  String paymentStatus;
  double totalAmount;

  //
  Currency currency;
  Vendor vendor;
  DeliveryAddress deliveryAddress;
  PaymentOption paymentOption;

  List<Product> products;

  Order({
    this.id,
    this.code,
    this.date,
    this.status,
    this.totalAmount,
  });

  factory Order.fromJSON({
    dynamic jsonObject,
  }) {
    final order = Order();
    order.id = jsonObject["id"];
    order.code = jsonObject["code"];
    order.date = jsonObject["created_at"];
    order.status = jsonObject["status"];
    order.paymentStatus = jsonObject["payment_status"];
    order.totalAmount = double.parse(jsonObject["total_amount"].toString());
    order.currency = Currency.fromJson(
      currencyJSONObject: jsonObject["currency"],
    );

    order.vendor = Vendor.fromJSON(
      jsonObject: jsonObject["vendor"],
      withExtras: false,
    );

    order.deliveryAddress = DeliveryAddress.fromJSON(
      jsonObject: jsonObject["delivery_address"],
    );

    order.paymentOption = PaymentOption.fromJSON(
      jsonObject: jsonObject["payment_option"],
    );

    //products
    order.products = (jsonObject["products"] as List).map(
      (productJSONObject) {
        final mFood = Product.fromJSON(
          jsonObject: productJSONObject["product"],
          withExtras: false,
        );

        mFood.price = double.parse(productJSONObject["price"].toString());
        mFood.selectedQuantity = int.parse(
          productJSONObject["quantity"].toString(),
        );
        mFood.extrasString = productJSONObject["extras"] != null
            ? productJSONObject["extras"]
            : "";
        return mFood;
      },
    ).toList();
    return order;
  }

  String get formattedDate {
    final orderDateTime = DateTime.parse(this.date);
    return DateFormat('dd MMM, yyyy').format(orderDateTime);
  }
}
