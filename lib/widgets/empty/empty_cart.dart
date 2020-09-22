import 'package:flutter/material.dart';
import 'package:Doory/constants/app_images.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/cart.strings.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.defaultPadding(),
      child: ListView(
        children: <Widget>[
          Image.asset(
            AppImages.emptyCart,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Center(
            child: Text(
              CartStrings.emptyTitle,
              style: AppTextStyle.h4TitleTextStyle(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              CartStrings.emptyBody,
              style: AppTextStyle.h5TitleTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
