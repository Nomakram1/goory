import 'package:flutter/material.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/widgets/buttons/custom_button.dart';

class CustomLeadingOnlyAppBar extends StatelessWidget {
  const CustomLeadingOnlyAppBar({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: AppBar().preferredSize.height,
        left: AppPaddings.buttonPaddingSize,
      ),
      child: ButtonTheme(
        minWidth: 50,
        child: CustomButton(
          color: Colors.white70,
          padding: EdgeInsets.all(5),
          onPressed: this.onPressed,
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColor.primaryColor,
          ),
        ),
      ),
    );
  }
}
