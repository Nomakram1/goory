import 'package:flutter/material.dart';
import 'package:foodie/constants/app_sizes.dart';

class CorneredContainer extends StatelessWidget {
  CorneredContainer({
    Key key,
    this.child,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  final Widget child;
  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: AppSizes.containerBorderRadiusShape(
          radius: 5,
        ),
        color: this.color,
      ),
      clipBehavior: Clip.antiAlias,
      child: this.child,
    );
  }
}
