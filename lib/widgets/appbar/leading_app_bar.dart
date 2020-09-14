import 'package:flutter/material.dart';
import 'package:foodie/constants/app_color.dart';

class LeadingAppBar extends StatelessWidget {
  const LeadingAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back_ios,
        color: AppColor.primaryColor,
      ),
    );
  }
}
