import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/data/models/product.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/views/product_page.dart';
import 'package:foodie/widgets/cornered_container.dart';

class ProductListViewItem extends StatelessWidget {
  ProductListViewItem({
    Key key,
    this.product,
    @required this.vendor,
  }) : super(key: key);

  final Product product;
  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: AppPaddings.buttonPadding(),
      onPressed: () {
        //open food page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              product: product,
              vendor: vendor,
            ),
          ),
        );
      },
      color: Colors.white,
      elevation: 0,
      child: Row(
        children: <Widget>[
          //food image
          //if no food image was supplied, a shrink SizedBox will be added
          if (product.photoUrl.isNotEmpty)
            Hero(
              tag: product.id,
              child: CorneredContainer(
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
            )
          else
            SizedBox.shrink(),
          SizedBox(
            width: 20,
          ),
          //food info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.name,
                  style: AppTextStyle.h4TitleTextStyle(),
                ),
                Text(
                  "${vendor.currency.symbol} ${product.price}",
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
