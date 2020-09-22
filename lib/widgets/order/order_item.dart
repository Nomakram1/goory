import 'package:basic_utils/basic_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_sizes.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/data/models/order.dart';
import 'package:Doory/widgets/cornered_container.dart';

class OrderItem extends StatelessWidget {
  OrderItem({
    Key key,
    this.order,
    this.onPressed,
  }) : super(key: key);

  final Order order;
  final Function(Order) onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        this.onPressed(this.order);
      },
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          //order preview imgae
          CorneredContainer(
            child: CachedNetworkImage(
              imageUrl: this.order.vendor.featureImage,
              placeholder: (context, url) => Container(
                height: AppSizes.productImageHeight,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: AppSizes.productImageHeight,
              fit: BoxFit.cover,
              width: AppSizes.productImageWidth,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          //order info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.order.code.toUpperCase(),
                  style: AppTextStyle.h4TitleTextStyle(
                    color: AppColor.primaryColor,
                  ),
                ),
                Text(
                  this.order.formattedDate,
                  style: AppTextStyle.h5TitleTextStyle(),
                ),
                Text(
                  "${this.order.currency.symbol} ${this.order.totalAmount}",
                  style: AppTextStyle.h4TitleTextStyle(),
                ),
              ],
            ),
          ),

          //status
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColor.statusColor(
                status: this.order.status,
              ),
              borderRadius: AppSizes.containerBorderRadiusShape(
                radius: 10,
              ),
            ),
            child: Text(
              StringUtils.capitalize(this.order.status),
              style: AppTextStyle.h5TitleTextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
