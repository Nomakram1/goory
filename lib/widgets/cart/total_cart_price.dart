import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/cart.strings.dart';
import 'package:foodie/data/database/app_database_singleton.dart';
import 'package:foodie/data/models/currency.dart';
import 'package:foodie/data/models/product.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/utils/price.utils.dart';
import 'package:foodie/widgets/cart/amount_tile.dart';

class TotalCartPrice extends StatefulWidget {
  TotalCartPrice({
    Key key,
    this.currency,
  }) : super(key: key);

  final Currency currency;
  @override
  _TotalCartPriceState createState() => _TotalCartPriceState();
}

class _TotalCartPriceState extends State<TotalCartPrice> {
  //subtotal food amount
  double subTotalAmount = 0.0;
  double deliveryFee = 0.0;
  double totalAmount = 0.0;

  //food and vendor data stream
  StreamSubscription<List<Product>> foodListener;
  StreamSubscription<List<Vendor>> vendorListener;

  @override
  void initState() {
    super.initState();

    //listen to food items in cart
    foodListener = AppDatabaseSingleton.database.productDao
        .findAllProductsAsStream()
        .listen(
      (foods) {
        //set the subtotal amount to 0 before recalculating the subtotal amount
        subTotalAmount = 0.0;
        //loop through the foods to calculate the subtotal amount
        foods.forEach(
          (food) {
            subTotalAmount += food.priceWithExtras * food.selectedQuantity;
          },
        );
        //update the total order amount
        _updateTotalOrderAmount();
      },
    );

    //listen to food items in cart
    vendorListener =
        AppDatabaseSingleton.database.vendorDao.findAllVendorsAsStream().listen(
      (vendors) {
        //to avoid error when cart items are cleared
        if (vendors != null && vendors.length > 1) {
          //set the subtotal amount to 0 before recalculating the subtotal amount
          deliveryFee = vendors[0].deliveryFee;
          //update the total order amount
          _updateTotalOrderAmount();
        }
      },
    );
  }

  //update total order amount
  void _updateTotalOrderAmount() {
    setState(() {
      subTotalAmount = subTotalAmount;
      deliveryFee = deliveryFee;
      totalAmount = subTotalAmount + deliveryFee;
    });
  }

  @override
  void dispose() {
    super.dispose();
    foodListener.cancel();
    vendorListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //showing the sub total amount
          AmountTile(
            label: CartStrings.subTotal,
            labelTextStyle: AppTextStyle.h5TitleTextStyle(),
            amount:
                "${widget.currency.symbol} ${PriceUtils.intoDecimalPlaces(subTotalAmount)}",
            amountTextStyle: AppTextStyle.h3TitleTextStyle(),
          ),
          //showing the delivery fee
          AmountTile(
            label: CartStrings.deliveryFee,
            labelTextStyle: AppTextStyle.h5TitleTextStyle(),
            amount:
                "${widget.currency.symbol} ${PriceUtils.intoDecimalPlaces(deliveryFee)}",
            amountTextStyle: AppTextStyle.h3TitleTextStyle(),
          ),

          Divider(
            thickness: 2,
          ),
          AmountTile(
            label: CartStrings.totalAmount,
            labelTextStyle: AppTextStyle.h5TitleTextStyle(),
            amount:
                "${widget.currency.symbol} ${PriceUtils.intoDecimalPlaces(totalAmount)}",
            amountTextStyle: AppTextStyle.h3TitleTextStyle(),
          ),
        ],
      ),
    );
  }
}
