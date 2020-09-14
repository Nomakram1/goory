import 'package:flutter/material.dart';

class EmptyAppBar extends AppBar with PreferredSizeWidget {
  @override
  get preferredSize => Size.fromHeight(0);

  EmptyAppBar({
    Key key,
  }) : super(
          key: key,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          automaticallyImplyLeading: false, // hides leading widget
          flexibleSpace: SizedBox.shrink(),
          elevation: 0,
        );
}
