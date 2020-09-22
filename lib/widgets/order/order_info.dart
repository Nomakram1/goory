import 'package:flutter/material.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/order.strings.dart';
import 'package:Doory/data/models/order.dart';
import 'package:Doory/widgets/order/order_item.dart';
import 'package:Doory/widgets/order/order_product_info.dart';

class OrderInfo extends StatelessWidget {
  const OrderInfo({
    Key key,
    this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //info of order
          OrderItem(
            order: this.order,
          ),
          Divider(),
          //foods title/header
          Padding(
            padding: EdgeInsets.all(AppPaddings.buttonPaddingSize),
            child: Text(
              OrderStrings.products,
              style: AppTextStyle.h3TitleTextStyle(),
            ),
          ),

          //list of foods
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(AppPaddings.buttonPaddingSize),
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                return OrderProductInfo(
                  currency: this.order.currency,
                  product: this.order.products[index],
                );
              },
              itemCount: this.order.products.length,
            ),
          ),
        ],
      ),
    );
  }
}
