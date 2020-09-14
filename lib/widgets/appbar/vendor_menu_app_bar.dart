import 'package:flutter/material.dart';
import 'package:foodie/constants/app_color.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/data/models/menu.dart';

class VendorMenuAppBar extends StatefulWidget {
  VendorMenuAppBar({
    Key key,
    @required this.menus,
  }) : super(key: key);

  final List<Menu> menus;
  @override
  _VendorMenuAppBarState createState() => _VendorMenuAppBarState();
}

class _VendorMenuAppBarState extends State<VendorMenuAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      backgroundColor: Colors.white,
      primary: false,
      elevation: 1,
      forceElevated: true,
      floating: false,
      titleSpacing: 0,
      bottom: TabBar(
        labelColor: AppColor.primaryColor,
        unselectedLabelColor: Colors.black,
        isScrollable: true,
        indicatorWeight: 3.0,
        indicatorPadding: EdgeInsets.all(0),
        labelStyle: AppTextStyle.h4TitleTextStyle(),
        unselectedLabelStyle: AppTextStyle.h5TitleTextStyle(),
        tabs: widget.menus.map(
          (menu) {
            return Tab(
              text: menu.name,
            );
          },
        ).toList(),
      ),
    );
  }
}
