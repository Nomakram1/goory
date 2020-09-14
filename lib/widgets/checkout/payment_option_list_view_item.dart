import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/data/models/payment_option.dart';
import 'package:foodie/utils/ui_spacer.dart';

class PaymentOptionListViewItem extends StatelessWidget {
  const PaymentOptionListViewItem({
    Key key,
    @required this.paymentOption,
    @required this.onPressed,
  }) : super(key: key);

  final PaymentOption paymentOption;
  final Function(PaymentOption) onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white,
      elevation: 2,
      onPressed: () {
        this.onPressed(this.paymentOption);
      },
      padding: AppPaddings.mediumButtonPadding(),
      child: Row(
        children: <Widget>[
          //Payment option logo/image
          CachedNetworkImage(
            imageUrl: this.paymentOption.logo,
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.width * 0.1,
          ),
          UiSpacer.horizontalSpace(),
          //payment option name and description
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  this.paymentOption.name,
                  style: AppTextStyle.h4TitleTextStyle(),
                ),
                Text(
                  this.paymentOption.description,
                  style: AppTextStyle.h5TitleTextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          //arrow icon
          Icon(
            FlutterIcons.right_ant,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
