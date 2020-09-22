import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/data/models/category.dart';
import 'package:Doory/utils/ui_spacer.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    Key key,
    this.height = 50,
    this.width = 50,
    this.imageSize = 80,
    this.category,
    this.onPressed,
  }) : super(key: key);

  final Function onPressed;
  final double height;
  final double width;
  final double imageSize;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // padding: EdgeInsets.all(5),
      child: Container(
        // height: this.height,
        width: this.width,
        child: RaisedButton(
          // clipBehavior: Clip.antiAliasWithSaveLayer,
          onPressed: this.onPressed,
          shape: CircleBorder(),
          padding: EdgeInsets.all(15),
          color: Colors.white,
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UiSpacer.verticalSpace(space: 10),
              CachedNetworkImage(
                imageUrl: this.category.photo,
                height: this.imageSize,
                width: this.imageSize,
              ),
              UiSpacer.verticalSpace(space: 5),
              Text(
                this.category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.h6TitleTextStyle(),
              ),
              UiSpacer.verticalSpace(space: 10),
            ],
          ),
        ),
      ),
    );
  }
}
