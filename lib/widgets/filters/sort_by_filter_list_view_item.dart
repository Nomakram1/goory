import 'package:flutter/material.dart';
import 'package:foodie/constants/app_text_styles.dart';
import 'package:foodie/data/models/sort_by.dart';

class SortByListViewItem extends StatefulWidget {
  const SortByListViewItem({
    Key key,
    @required this.sortBy,
    @required this.selected,
  }) : super(key: key);

  final SortBy sortBy;
  final bool selected;

  @override
  _SortByListViewItemState createState() => _SortByListViewItemState();
}

class _SortByListViewItemState extends State<SortByListViewItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            widget.sortBy.iconData,
            color: widget.selected
                ? widget.sortBy.iconActiveColor
                : widget.sortBy.iconColor,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.sortBy.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.h5TitleTextStyle(
              color: widget.selected
                  ? widget.sortBy.iconActiveColor
                  : widget.sortBy.iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
