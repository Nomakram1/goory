import 'package:flutter/material.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_images.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/checkout.strings.dart';

class EmptyPaymentMethod extends StatelessWidget {
  const EmptyPaymentMethod({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.defaultPadding(),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.10),
        // color: AppColor.primaryColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            AppImages.emptyPaymentMethod,
            width: 100,
            height: 100,
          ),
          Text(
            CheckoutStrings.emptyPaymentOptionsTitle,
            style: AppTextStyle.h4TitleTextStyle(),
          ),
          Text(
            CheckoutStrings.emptyPaymentOptionsBody,
            style: AppTextStyle.h5TitleTextStyle(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
