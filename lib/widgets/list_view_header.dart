import 'package:flutter/material.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/utils/ui_spacer.dart';

class ListViewHeader extends StatelessWidget {
  const ListViewHeader({
    Key key,
    this.title,
    this.subTitle,
    this.iconData,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          this.iconData,
        ),
        UiSpacer.horizontalSpace(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                this.title,
                style: AppTextStyle.h4TitleTextStyle(),
              ),
              Text(
                this.subTitle,
                style: AppTextStyle.h5TitleTextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
