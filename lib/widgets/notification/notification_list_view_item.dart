import 'package:flutter/material.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/data/models/notification_model.dart';
import 'package:foodie/utils/ui_spacer.dart';

class NotificationListViewItem extends StatelessWidget {
  const NotificationListViewItem({
    Key key,
    @required this.notification,
    this.onPressed,
  }) : super(key: key);

  final NotificationModel notification;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: AppPaddings.defaultPadding(),
      color: notification.read == 0 ? Colors.grey[100] : Colors.white,
      elevation: notification.read == 0 ? 5 : 3,
      onPressed: this.onPressed,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              notification.title,
              style: AppTextStyle.h4TitleTextStyle(),
            ),
            UiSpacer.verticalSpace(space: 2),
            Text(
              notification.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.h5TitleTextStyle(),
            ),
            UiSpacer.verticalSpace(space: 5),
            Text(
              notification.formattedTimeStamp,
              style: AppTextStyle.h6TitleTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
