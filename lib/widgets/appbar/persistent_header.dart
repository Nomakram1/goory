import 'package:flutter/material.dart';

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double height;
  final double elevation;

  PersistentHeader({
    this.widget,
    this.height = 56.0,
    this.elevation = 0.0,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: height,
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.white,
        elevation: elevation,
        child: Center(child: widget),
      ),
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
