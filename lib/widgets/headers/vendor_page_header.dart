import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_sizes.dart';
import 'package:foodie/constants/app_strings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/cart.strings.dart';
import 'package:foodie/constants/strings/vendor.strings.dart';
import 'package:foodie/data/models/vendor.dart';
import 'package:foodie/widgets/buttons/delivery_time_button.dart';

class VendorPageHeader extends StatelessWidget {
  const VendorPageHeader({
    Key key,
    @required this.vendor,
  }) : super(key: key);

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: new SliverChildListDelegate(
        [
          Stack(
            children: <Widget>[
              //vendor feature image
              Hero(
                tag: vendor.slug,
                child: CachedNetworkImage(
                  imageUrl: vendor.featureImage,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: AppSizes.vendorPageImageHeight,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),

              //curved top
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: AppSizes.vendorPageInfoCurveHeight,
                  decoration: BoxDecoration(
                    borderRadius: AppSizes.containerTopBorderRadiusShape(),
                    color: Colors.white,
                  ),
                ),
              ),

              //delivery time
              Positioned(
                right: 20,
                top: AppSizes.vendorPageInfoTopMargin,
                child: DeliveryTimeButton(
                  deliveryTime: vendor.deliveryTime,
                ),
              ),
            ],
          ),

          //Vendor info
          Padding(
            // padding: AppPaddings.vendorPageContentPadding(),
            padding: EdgeInsets.fromLTRB(
              AppPaddings.contentPaddingSize,
              AppPaddings.contentPaddingSize,
              AppPaddings.contentPaddingSize,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //vendor name text
                Text(
                  vendor.name,
                  style: AppTextStyle.h2TitleTextStyle(),
                ),

                //vendor is open or not and vendor address
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      VendorStrings.open,
                      style: AppTextStyle.h5TitleTextStyle(
                        color: AppColor.vendorOpenColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      AppStrings.dot,
                    ),
                    Text(
                      vendor.address,
                      style: AppTextStyle.h5TitleTextStyle(),
                    ),
                  ],
                ),

                Divider(
                  height: 30,
                ),

                //rating, deliver fee
                RichText(
                  text: TextSpan(
                    style: AppTextStyle.h5TitleTextStyle(),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.star,
                          size: 16,
                        ),
                      ),
                      TextSpan(
                        text: " ${vendor.rating} ",
                      ),
                      TextSpan(
                        text: " ${AppStrings.dot} ",
                      ),
                      TextSpan(
                        text:
                            "${AppStrings.minimumOrderLabel}${vendor.currency.symbol} ${vendor.minimumOrder}",
                      ),
                      TextSpan(
                        text: " ${AppStrings.dot} ",
                      ),
                      TextSpan(
                        text: CartStrings.deliveryFee,
                      ),
                      TextSpan(
                        text: "${vendor.currency.symbol} ${vendor.deliveryFee}",
                      ),
                    ],
                  ),
                ),
                //search bar

                Divider(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
