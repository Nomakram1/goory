import 'package:flutter/material.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_strings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/widgets/buttons/custom_button.dart';

class DeliveryTimeButton extends StatefulWidget {
  DeliveryTimeButton({
    Key key,
    this.deliveryTime,
  }) : super(key: key);

  final String deliveryTime;

  @override
  _DeliveryTimeButtonState createState() => _DeliveryTimeButtonState();
}

class _DeliveryTimeButtonState extends State<DeliveryTimeButton> {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      elevation: 5,
      disabledColor: AppColor.primaryColor,
      disabledTextColor: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.access_time,
            size: 16,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            widget.deliveryTime,
            style: AppTextStyle.h4TitleTextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            AppStrings.deliveryTimeUnit,
            style: AppTextStyle.h6TitleTextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
