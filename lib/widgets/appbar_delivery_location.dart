import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_strings.dart';
import 'package:foodie/constants/app_text_styles.dart';

class AppBarDeliveryLocation extends StatefulWidget {
  AppBarDeliveryLocation({
    Key key,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  _AppBarDeliveryLocationState createState() => _AppBarDeliveryLocationState();
}

class _AppBarDeliveryLocationState extends State<AppBarDeliveryLocation> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: widget.onPressed,
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(
              FlutterIcons.location_arrow_faw,
              color: AppColor.iconHintColor,
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppStrings.deliveryTo,
                    style: AppTextStyle.h5TitleTextStyle(
                      color: AppColor.primaryColorDark,
                    ),
                  ),
                  Text(
                    "Lapaz, Accra, Ghana",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.h5TitleTextStyle(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
