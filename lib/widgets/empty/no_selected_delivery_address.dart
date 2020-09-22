import 'package:flutter/material.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_images.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/checkout.strings.dart';

class NoSelectedDeliveryAddresses extends StatelessWidget {
  const NoSelectedDeliveryAddresses({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.defaultPadding(),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.10),
        // color: AppColor.primaryColor,
      ),
      child: Column(
        children: <Widget>[
          Image.asset(
            AppImages.emptyDeliveryAddress,
            width: 100,
            height: 100,
          ),
          Text(
            CheckoutStrings.emptyDeliveryAddressTitle,
            style: AppTextStyle.h4TitleTextStyle(),
          ),
          Text(
            CheckoutStrings.emptyDeliveryAddressBody,
            style: AppTextStyle.h5TitleTextStyle(),
          ),
        ],
      ),
    );
  }
}
