
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListViewPullUpFooter extends StatelessWidget {
  const ListViewPullUpFooter({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      height: 200,
      loadStyle: LoadStyle.ShowAlways,
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text("Pull up to load more");
        } else if (mode == LoadStatus.loading) {
          body = ( Platform.isIOS ) ? CupertinoActivityIndicator() : SizedBox(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          );

          // body = TaskOfferShimmerListViewItem();
        } else if (mode == LoadStatus.failed) {
          body = Text("Load Failed! Click retry!");
        } else if (mode == LoadStatus.canLoading) {
          body = Text("Release to load more");
        } else {
          body = Text("No more Data");
        }
        return Container(
          height: 60.0,
          child: Center(child: body),
        );
      },
    );
  }
}
