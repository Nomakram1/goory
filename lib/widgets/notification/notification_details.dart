import 'package:flutter/material.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/data/models/notification_model.dart';
import 'package:foodie/utils/ui_spacer.dart';

class NotificationDetails extends StatelessWidget {
  const NotificationDetails({
    Key key,
    this.notification,
  }) : super(key: key);

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      child: ListView(
        padding: AppPaddings.defaultPadding(),
        children: <Widget>[
          //notification title
          Text(
            notification.title,
            style: AppTextStyle.h3TitleTextStyle(),
          ),
          //notification timestamp
          Text(
            notification.formattedTimeStamp,
            style: AppTextStyle.h6TitleTextStyle(),
          ),
          UiSpacer.verticalSpace(),
          //notification body
          Text(
            notification.body,
            style: AppTextStyle.h5TitleTextStyle(),
          ),
        ],
      ),
    );
  }
}
