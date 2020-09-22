import 'package:flutter/material.dart';
import 'package:Doory/constants/app_images.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/constants/strings/search.strings.dart';

class EmptyVendor extends StatelessWidget {
  const EmptyVendor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Image.asset(
            AppImages.emptySearch,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Center(
            child: Text(
              SearchStrings.emptyTitle,
              style: AppTextStyle.h4TitleTextStyle(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              SearchStrings.emptyBody,
              style: AppTextStyle.h5TitleTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
