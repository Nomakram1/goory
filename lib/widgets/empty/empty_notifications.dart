import 'package:flutter/material.dart';
import 'package:foodie/constants/app_images.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/constants/strings/profile/notification.strings.dart';

class EmptyNotification extends StatelessWidget {
  const EmptyNotification({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.defaultPadding(),
      child: ListView(
        children: <Widget>[
          Image.asset(
            AppImages.emptyNotification,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Center(
            child: Text(
              NotificationStrings.emptyTitle,
              style: AppTextStyle.h4TitleTextStyle(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              NotificationStrings.emptyBody,
              style: AppTextStyle.h5TitleTextStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
