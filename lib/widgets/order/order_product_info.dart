import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/data/models/currency.dart';
import 'package:foodie/data/models/product.dart';
import 'package:foodie/utils/ui_spacer.dart';
import 'package:foodie/widgets/cornered_container.dart';

class OrderProductInfo extends StatelessWidget {
  const OrderProductInfo({
    Key key,
    this.product,
    this.currency,
  }) : super(key: key);

  final Product product;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          //food image
          CorneredContainer(
            child: CachedNetworkImage(
              imageUrl: product.photoUrl,
              placeholder: (context, url) => Container(
                height: AppSizes.productImageHeight,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: AppSizes.productImageHeight,
              width: AppSizes.productImageWidth,
              fit: BoxFit.cover,
            ),
          ),

          UiSpacer.horizontalSpace(),
          //food info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.name,
                  style: AppTextStyle.h4TitleTextStyle(),
                ),
                (product.extrasString != null)
                    ? Text(
                        product.extrasString,
                        style: AppTextStyle.h5TitleTextStyle(),
                      )
                    : UiSpacer.horizontalSpace(space: 0),
                Text(
                  "${this.currency.symbol} ${product.price}",
                  style: AppTextStyle.h5TitleTextStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
