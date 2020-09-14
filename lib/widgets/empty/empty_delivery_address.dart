import 'package:flutter/material.dart';
import 'package:foodie/constants/app_images.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/profile/delivery_address.strings.dart';

class EmptyDeliveryAddresses extends StatelessWidget {
  const EmptyDeliveryAddresses({
    Key key,
    this.scrollable = true,
  }) : super(key: key);

  final bool scrollable;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.defaultPadding(),
      child: ListView(
        shrinkWrap: !this.scrollable,
        physics: this.scrollable
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        children: <Widget>[
          Image.asset(
            AppImages.emptyDeliveryAddress,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Center(
            child: Text(
              DeliveryaAddressStrings.emptyTitle,
              style: AppTextStyle.h4TitleTextStyle(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              DeliveryaAddressStrings.emptyBody,
              style: AppTextStyle.h5TitleTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
